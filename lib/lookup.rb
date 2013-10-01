# All lookup types implement this mixin, which
# defines the interface lookups use to talk to 
# the main controller.
# 
# Author:: Gaurav Vaidya
# Copyright:: Copyright (c) 2013 Gaurav Vaidya
# License:: MIT

module Lookup

  # Returns true if this Lookup supports this id.
  def supported?(id)
    return not canonical(id).nil?
  end

  # Returns a canonical form of the identifier,
  # preferably as a URL.
  def canonical(id)
    raise NotImplementedError
  end

  # Returns a dictionary of parsed values with
  # BibTeX names by looking up the provided id.
  def lookup(id)
    raise NotImplementedError
  end
 
end
