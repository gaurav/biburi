require 'biburi'
require 'biburi/driver'
require 'net/http'
require 'json'

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

  # Returns a dictionary of parsed values with
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

    elsif as_json.length > 1 then
        # More than one search result? Report all the DOI matches
        # as 'title'.
        all_dois = []
        as_json.each do |doi|
            all_dois.push(doi['doi'])
        end

        return {
            "title" => "#{as_json.length()} DOIs returned: " + all_dois.join(', ')
        }
    end

    # A single search result? Make sure the DOI matches, then report it.
    match = as_json[0]
    unless match['doi'].downcase == canonical_id.downcase then
        return nil
    end

    return {
        "title" => match["fullCitation"],
        "year" => match["year"]
    }
  end
end
