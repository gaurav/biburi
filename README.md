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

    results = BibURI::lookup('doi:10.1038/171737a0')

Full documentation is [available online at RubyDoc.org](http://rubydoc.org/github/gaurav/biburi/master/frames).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new pull request

## Pushing to RubyGems

(from http://stackoverflow.com/questions/7196489/using-bundlers-rake-release-with-git-flow)

1. git flow release start 0.0.9
2. ...
3. git flow release finish -n 0.0.9
4. git checkout master
5. rake release
6. git checkout develop

[1]: https://secure.travis-ci.org/gaurav/biburi.png
[2]: http://travis-ci.org/gaurav/biburi
[3]: https://coveralls.io/repos/gaurav/biburi/badge.png?branch=master
[4]: https://coveralls.io/r/gaurav/biburi?branch=master
[5]: https://gemnasium.com/gaurav/biburi.png
[6]: https://gemnasium.com/gaurav/biburi
