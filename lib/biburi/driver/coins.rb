# A driver to read BibTeX from web pages by reading
# in COinS on that page. Find out more about COinS
# at: http://ocoins.info/
#
# Author:: Gaurav Vaidya
# Copyright:: Copyright (c) 2013 Gaurav Vaidya
# License:: MIT

require 'biburi'
require 'biburi/driver'
require 'net/http'
require 'json'
require 'bibtex'
require 'uri'
require 'nokogiri'
require 'cgi'

# This driver reads COinS citations in an HTML
# page and returns them. It defaults to returning
# a single citation, but can be used to return all
# citations.

module BibURI::Driver::COinS
  include BibURI::Driver

  # We support an identifier if we can make them look
  # canonical.
  def self.supported?(id)
    canonical = self.canonical(id)
    return !(canonical.nil?)
  end

  # The canonical form of this identifier is the
  # normalized URI, IF it has a scheme of 'http'
  # or 'https'.
  def self.canonical(id)
    uri = URI.parse(id)

    unless uri.scheme == 'http' || uri.scheme == 'https'
        return nil
    end

    return uri.to_s

  rescue URI::InvalidURIError
    # If there is an error in the URI, it is not an identifier.
    nil
  end

  # Returns a list of parsed values with
  # BibTeX names by looking up the provided id (a URL).
  # 
  # This will call self.lookup_all(), and then only
  # return the first match. For pages like Mendeley, this is
  # necessary to avoid pulling in 'related to' citations
  # or to pull in all entries.
  def self.lookup(id)
    self.lookup_all(id) do |first_only|
      return [first_only]
    end
  end
   
  # This method returns ALL COinS on this page. For Mendeley,
  # this will return the pages' COinS as well as all related
  # papers. Use self.lookup() to find a single one.
  def self.lookup_all(id)
    # Calculate the canonical identifier.
    url = canonical(id)
    if url.nil? then
        return nil
    end

    # Retrieve the HTML.
    content = Net::HTTP.get(URI(url))
    doc = Nokogiri::HTML(content)
    spans = doc.css('span.Z3988')

    # Go through results and format them as BibTeX::Entry.
    # We support both 
    results = [] unless block_given?
        
    spans.each do |span|
        coins = span['title']

        bibentry = self.coins_to_bibtex(coins)

        # Set identifiers so we know where this came from.
        bibentry[:url] = url

        identifiers = Array.new
        identifiers.push(bibentry[:identifiers]).flatten! if bibentry.field?('identifiers')
        identifiers.push(url)
        bibentry.add(:identifiers, identifiers.join("\n"))

        # See if we have a DOI.
        identifiers.each do |identifier|
            match = identifier.match(/^(?:http:\/\/dx\.doi\.org\/|doi:|info:doi\/)(.*)$/i) 
            if match then
                bibentry[:doi] = match[1] 
            end
        end

        # Yield values or return array.
        if block_given? then
            yield(bibentry)
        else
            results.push(bibentry)
        end 
    end

    # If we built an array, return it.
    unless block_given? then
        return results
    end
  end

  # Converts a COinS string to a BibTeX entry.
  def self.coins_to_bibtex(coins)
    # Create a BibTeX entry to store these values.
    bibentry = BibTeX::Entry.new

    # If we have COinS data, we have a lot more data.
    coins_kv = CGI::parse(coins)
    metadata = {}
    coins_kv.each do |key, val|
        if val.length == 1 then
            metadata[key] = val[0]
        else
            metadata[key] = val
        end
    end

    # COinS values are explained at http://ocoins.info/cobg.html
    # and in http://ocoins.info/cobgbook.html.

    # If we're not Z3988-2004, skip out.
    ctx_ver = metadata['ctx_ver']
    if ctx_ver != 'Z39.88-2004' then
        ctx_ver = "" if ctx_ver.nil?
        raise "ctx_ver is: '#{ctx_ver}'"
    end

    # Add ALL the identifiers.
    identifiers = []
    identifiers.push(metadata['rft_id']) if metadata.key?('rft_id')
    bibentry[:identifiers] = identifiers unless identifiers.flatten.length == 0

    # COinS supports some types
    genre = metadata['rft.genre']
    if genre == 'article' then
        bibentry.type = "article"
    elsif genre == 'book' then
        bibentry.type = "book"
    elsif genre == 'bookitem' then
        bibentry.type = "inbook"
    elsif genre == 'proceeding' then
        bibentry.type = "proceedings"
    elsif genre == 'conference' then
        bibentry.type = "inproceedings"
    elsif genre == 'report' then
        bibentry.type = "techreport"
    end 
    
    # Journal title: title, jtitle
    journal_title = metadata['rft.title']       # The old-style journal title.
    journal_title ||= metadata['rft.stitle']    # An abbreviated title.
    journal_title ||= metadata['rft.jtitle']    # Complete title.
    bibentry[:journal] = journal_title

    # Book title: btitle
    if metadata.key?('rft.btitle')
        if journal_title
            bibentry[:booktitle] = metadata['rft.btitle']
        else
            bibentry[:title] = metadata['rft.btitle']
        end
    end

    # Pages: spage, epage
    pages = metadata['rft.pages']       # If only pages are provided

    # Expand a single dash to a BibTeX-y double-dash.
    pages.gsub!(/([^\-])\-([^\-])/, '\1--\2') unless pages.nil?

    pages ||= metadata['rft.spage'] + "--" + metadata['rft.epage']
                                    # If we have start and end pages
    bibentry[:pages] = pages

    # Authors are all in 'rft.au'
    authors = []
    metadata['rft.au'] = [ metadata['rft.au'] ] unless metadata['rft.au'].kind_of?(Array)
    metadata['rft.au'].each do |author|
        authors.push(BibTeX::Name.parse(author)) unless author.nil?
    end

    # However! Sometimes a name is in aufirst/aulast
    # and also in au; and sometimes it's only in aufirst/aulast.
    first_author = BibTeX::Name.new
    first_author.last = metadata['rft.aulast']
    first_author.suffix = metadata['rft.ausuffix'] if metadata.key?('rft.ausuffix')
    if metadata.key?('rft.aufirst') then
        first_author.first = metadata['rft.aufirst']
    elsif metadata.key?('rft.auinit') then
        first_author.first = metadata['rft.auinit']
    elsif 
        first_author.first = metadata['rft.auinit1']
        first_author.first += " " + metadata['rftinitm'] if metadata.key?('rftinitm')
    end
    if !authors.include?(first_author) then
        authors.unshift(first_author)
    end

    bibentry[:author] = BibTeX::Names.new(authors)

    # Dates. 
    date = metadata['rft.date']
    bibentry[:date] = date

    # Citeulike dates are easy to parse. 
    unless date.nil? then
        if match = date.match(/^(\d{4})$/) then
            bibentry[:year] = match[1] 

        elsif match = date.match(/^(\d{4})-(\d{1,2})$/) then
            bibentry[:year] = match[1] 
            bibentry[:month] = match[2] 

        elsif match = date.match(/^(\d{4})-(\d{1,2})-(\d{1,2})$/) then
            bibentry[:year] = match[1] 
            bibentry[:month] = match[2] 
            bibentry[:day] = match[3] 

        end
    end

    # Map remaining fields to BibTeX.
    standard_mappings = {
        "rft.atitle" =>     "title",
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

        "rft.place" =>      "address",
        "rft.pub" =>        "publisher",
        "rft.edition" =>    "edition",
        "rft.tpages" =>     "total_pages",
        "rft.series" =>     "series",
        "rft.bici" =>       "bici"
    }

    standard_mappings.keys.each do |field|
        if metadata.key?(field) then
            bibentry[standard_mappings[field]] = metadata[field]
        end
    end

    return bibentry
  end
end
