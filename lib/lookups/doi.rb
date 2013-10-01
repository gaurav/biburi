# Look up a DOI using the CrossRef web service.
#
# Author:: Gaurav Vaidya
# Copyright:: Copyright (c) 2013 Gaurav Vaidya
# License:: MIT

require '../lookup.rb'
require 'json'

class DOI
  Implements Lookup

  # The canonical form of a DOI is:
  # http://dx.doi.org/10.1234/abcd-5678
  def canonical(id)
    # Might be 'doi:...'
    match = id =~ /^doi:(?<doi>.*)$/
    if match
        return "http://dx.doi.org/#{match[:doi]}"
    end

    match = id =~ /^https?:\/\/dx\.doi\.org\/(?<doi>.*)$/
    if match
        return "http://dx.doi.org/#{match[:doi]}"
    end
  end

  # Returns a dictionary of parsed values with
  # BibTeX names by looking up the provided id.
  def lookup(id)
    raise NotImplementedError
  end
 

end
