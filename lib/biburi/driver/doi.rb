require 'biburi'
require 'biburi/driver'
require 'json'

module BibURI::Driver::DOI
  include BibURI::Driver

  # The canonical form of a DOI is:
  # http://dx.doi.org/10.1234/abcd-5678
  def self.canonical(id)
    # Might be 'doi:...'
    match = id.match(/^doi:(.*)$/)
    if match
        return "http://dx.doi.org/" + match[1]
    end

    match = id.match(/^http:\/\/dx\.doi\.org\/(.*)$/)
    if match
        return "http://dx.doi.org/" + match[1]
    end

    # If no match, return nil.
    nil
  end

  # Returns a dictionary of parsed values with
  # BibTeX names by looking up the provided id.
  def self.lookup(id)
    raise NotImplementedError
  end

end
