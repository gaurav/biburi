# All lookup types implement this mixin, which
# defines the interface lookups use to talk to 
# the main controller.
# 
# Author:: Gaurav Vaidya
# Copyright:: Copyright (c) 2013 Gaurav Vaidya
# License:: MIT

require 'biburi'

module BibURI::Driver
  # An array of drivers in order of preference. The
  # first driver which supports the ID and which
  # provides a valid lookup will stop processing.
  @@drivers = Array.new

  # Return a list of drivers.
  def self.drivers
    return @@drivers
  end

  # Returns true if this Lookup supports this id.
  def self.supported?(id)
    raise NotImplementedError
  end

  # Returns a canonical form of the identifier,
  # preferably as a URL.
  def self.canonical(id)
    raise NotImplementedError
  end

  # Returns a dictionary of parsed values with
  # BibTeX names by looking up the provided id.
  def self.lookup(id)
    raise NotImplementedError
  end
 
end

# Load all the drivers, and add them to BibURI::Driver
# in order of preference.
require "biburi/driver/doi"
require "biburi/driver/coins"

module BibURI::Driver
  @@drivers = [
    BibURI::Driver::DOI,
    BibURI::Driver::COinS
  ]
end

