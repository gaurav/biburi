# BibURI looks up URIs refering to citations (such as DOIs,
# Mendeley or Zotero URLs, and so on) and extracts the BibTeX
# data associated with them.
#
# Author:: Gaurav Vaidya
# Copyright:: Copyright (c) 2013 Gaurav Vaidya

require 'biburi/version'

module BibURI
  # Returns a list of all drivers.
  def self.drivers
    return BibURI::Driver::drivers
  end

  # Query all the drivers in the order
  # they are recorded in; return the results
  # for the first driver.
  def self.lookup(id)
    self.drivers.each do |driver|
      if driver.supported?(id) then
        results = driver.lookup(id)  
        if !results.nil? then
          return results
        end
      end
    end

    return nil
  end
end

require 'biburi/driver'
