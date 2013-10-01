# BibURI looks up URIs refering to citations (such as DOIs,
# Mendeley or Zotero URLs, and so on) and extracts the BibTeX
# data associated with them.
#
# Author:: Gaurav Vaidya
# Copyright:: Copyright (c) 2013 Gaurav Vaidya

require 'biburi/version'

module BibURI
    def self.drivers
        return BibURI::Driver::drivers
    end
end

require 'biburi/driver'
