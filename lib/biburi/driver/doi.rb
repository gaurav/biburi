# A driver to read BibTeX for DOI via CrossRef's
# public API: http://search.crossref.org/help/api
#
# Author:: Gaurav Vaidya
# Copyright:: Copyright (c) 2013 Gaurav Vaidya
# License:: MIT

require 'biburi'
require 'biburi/driver'
require 'biburi/driver/coins'
require 'net/http'
require 'json'
require 'bibtex'
 
# This driver provides information in BibTeX on a DOI by
# querying CrossRef's metadata search API. 

module BibURI::Driver::DOI
  include BibURI::Driver

  # We support an identifier if we can make them look
  # canonical.
  def self.supported?(id)
    canonical = BibURI::Driver::DOI::canonical(id)
    return !(canonical.nil?)
  end

  # The canonical form of a DOI can be one of
  # - http://dx.doi.org/10.1234/abcd-5678
  # - doi:10.1234/abcd-5678
  def self.canonical(id)
    # doi:10.1234/abcd-5678
    match = id.match(/^doi:(.*)$/i)
    if match
        return "http://dx.doi.org/" + match[1]
    end

    # http://dx.doi.org/10.1234/abcd-5678
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
    # Calculate the canonical identifier.
    canonical_id = canonical(id)
    if canonical_id.nil? then
        return nil
    end

    # Search for the DOI on CrossRef.
    crossref_url = "http://search.crossref.org/dois?" + 
        URI.encode_www_form([["q", canonical_id]])

    content = Net::HTTP.get(URI(crossref_url))
    as_json = JSON.parse(content)

    # No values returned? Returned nil so that the search
    # can continue.
    if as_json.length == 0 then
        return nil
    end

    # Go through results and format them as BibTeX::Entry.
    # We support both 
    results = [] unless block_given?
    as_json.each do |match|
        # Skip non-identical DOI matches.
        next unless match['doi'].downcase == canonical_id.downcase

        # Create a BibTeX entry to store these values.
        bibentry = BibTeX::Entry.new

        # Process any COinS content first, if any.
        if match.key?('coins') then
            bibentry = BibURI::Driver::COinS::coins_to_bibtex(match['coins'])
        end

        # Set identifiers so we know where this came from.
        bibentry[:url] = canonical_id

        identifiers = Array.new
        identifiers.push(bibentry[:identifiers]).flatten! if bibentry.field?('identifiers')
        identifiers.push(canonical_id)
        bibentry.add(:identifiers, identifiers.join("\n"))

        bibentry[:doi] = canonical_id.match(/^http:\/\/dx\.doi\.org\/(.*)$/)[1]

        # CrossRef itself provides a full citation and year.
        if !bibentry.has_field?('title') and match.key?('fullCitation') then
            bibentry[:title] = match['fullCitation']
        end

        if !bibentry.has_field?('year') and match.key?('year') then
            bibentry[:year] = match['year'] 
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
end
