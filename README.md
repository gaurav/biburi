# BibURI

[![Gem Version](https://badge.fury.io/rb/biburi.png)](http://badge.fury.io/rb/biburi)
[![Continuous Integration Status][1]][2]
[![Coverage Status][3]][4]
[![Dependency Status][5]][6]

This is a gem to extract BibTeX information for URIs which refer to bibliographic
resources, such as DOIs, Biodiversity Heritage Library links, and others.

Currently, BibURI supports the following types of data:

 - DOIs (via CrossRef)

## Installation

Add this line to your application's Gemfile:

    gem 'biburi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install biburi

## Usage

BibURI mainly works out of a single method:

    require 'biburi'

    entry = BibURI::lookup('doi:10.1038/171737a0')
    # => [#<BibTeX::Entry identifiers = info:doi/http://dx.doi.org/10.1038/171737a0 http://dx.doi.org/10.1038/171737a0, journal = Nature, pages = 737--738, author = WATSON, J. D. and CRICK, F. H. C., date = 1953, year = 1953, title = Molecular Structure of Nucleic Acids: A Structure for Deoxyribose Nucleic Acid, volume = 171, number = 4356, url = http://dx.doi.org/10.1038/171737a0, doi = 10.1038/171737a0>]

Full documentation is [available online at RubyDoc.org](http://rubydoc.org/github/gaurav/biburi/master/frames).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new pull request

[1]: https://secure.travis-ci.org/gaurav/biburi.png
[2]: http://travis-ci.org/gaurav/biburi
[3]: https://coveralls.io/repos/gaurav/biburi/badge.png?branch=master
[4]: https://coveralls.io/r/gaurav/biburi?branch=master
[5]: https://gemnasium.com/gaurav/biburi.png
[6]: https://gemnasium.com/gaurav/biburi
