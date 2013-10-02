require 'biburi'
require 'biburi/driver'
require 'net/http'
require 'json'
require 'bibtex'

module BibURI::Driver::DOI
  include BibURI::Driver

  def self.supported?(id)
    canonical = BibURI::Driver::DOI::canonical(id)
    return !(canonical.nil?)
  end

  # The canonical form of a DOI is:
  # http://dx.doi.org/10.1234/abcd-5678
  def self.canonical(id)
    # Might be 'doi:...'
    match = id.match(/^doi:(.*)$/i)
    if match
        return "http://dx.doi.org/" + match[1]
    end

    match = id.match(/^http:\/\/dx\.doi\.org\/(.*)$/i)
    if match
        return "http://dx.doi.org/" + match[1]
    end

    # If no match, return nil.
    nil
  end

  # Returns a list of parsed values with
  # BibTeX names by looking up the provided id.
  def self.lookup(id)
    canonical_id = canonical(id)
    if canonical_id.nil? then
        return nil
    end

    crossref_url = "http://search.crossref.org/dois?" + 
        URI.encode_www_form([["q", canonical_id]])

    content = Net::HTTP.get(URI(crossref_url))
    as_json = JSON.parse(content)

    if as_json.length == 0 then
        # No values returned? Returned nil so that the search
        # can continue.
        return nil
    end

    results = [] unless block_given?
    as_json.each do |match|
        # Skip non-identical DOI matches.
        next unless match['doi'].downcase == canonical_id.downcase

        # Create a BibTeX entry to store these values.
        bibentry = BibTeX::Entry.new

        # Set identifiers so we know where this came from.
        bibentry[:url] = canonical_id
        bibentry[:doi] = canonical_id.match(/^http:\/\/dx\.doi\.org\/(.*)$/)[1]

        # Set up from values from CrossRef.
        if match.key?('fullCitation') then
            bibentry[:title] = match['fullCitation']
        end

        if match.key?('year') then
            bibentry[:year] = match['year'] 
        end
        
        # If we have COinS data, we're in business.
        if match.key?('coins') then
            coins_kv = CGI::parse(match['coins'])
            metadata = {}
            coins_kv.each do |key, val|
                if val.length == 1 then
                    metadata[key] = val[0]
                else
                    metadata[key] = val
                end
            end

            # COinS values are explained at http://ocoins.info/cobg.html
            # Some values need to be handled separately.
            
            # Journal title: title, jtitle
            journal_title = metadata['rft.title']       # The old-style journal title.
            journal_title ||= metadata['rft.stitle']    # An abbreviated title.
            journal_title ||= metadata['rft.jtitle']    # Complete title.
            bibentry[:journal] = journal_title

            # Pages: spage, epage
            pages = metadata['rft.pages']       # If only pages are provided
            pages ||= metadata['rft.spage'] + "-" + metadata['rft.epage']
                                            # If we have start and end pages
            bibentry[:pages] = pages

            # Authors are all in 'rft.au'
            authors = BibTeX::Names.new
            metadata['rft.au'].each do |author|
                # if author.aufirst then 
                #    authors.add(BibTeX::Name.new({
                #        :first => author.aufirst,
                #        :last => author.aulast,
                #        :suffix => author.ausuffix
                #    }))
                #elsif author.aucorp then
                #    authors.add(author.aucorp)
                #else
                authors.add(BibTeX::Name.parse(author))
                #end
            end
            bibentry[:author] = authors

            # COinS supports some types
            genre = metadata['rft.genre']
            if genre == 'article' then
                bibentry.type = "article"
            elsif genre == 'proceeding' || genre == 'conference' then
                bibentry.type = "inproceeding"
            end 

            # Map remaining fields to BibTeX.
            standard_mappings = {
                "rft.atitle" =>     "title",
                "rft.date" =>       "date",
                "rft.volume" =>     "volume",
                "rft.issue" =>      "number",
                "rft.artnum" =>     "article_number",
                "rft.issn" =>       "issn",
                "rft.eissn" =>      "eissn",
                "rft.isbn" =>       "isbn",
                "rft.coden" =>      "CODEN",
                "rft.sici" =>       "SICI",
                "rft.chron" =>      "chronology",
                "rft.ssn" =>        "season",
                "rft.quarter" =>    "quarter",
                "rft.part" =>       "part",
            }
            standard_mappings.keys.each do |field|
                if metadata.key?(field) then
                    bibentry[standard_mappings[field]] = metadata[field]
                end
            end
        end

        # Yield values or return array.
        if block_given? then
            yield(bibentry)
        else
            results.push(bibentry)
        end 
    end

    unless block_given? then
        return results
    end
  end
end
