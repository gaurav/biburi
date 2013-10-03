# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'biburi/version'

Gem::Specification.new do |spec|
  spec.name          = "biburi"
  spec.version       = BibURI::VERSION
  spec.authors       = ["Gaurav Vaidya"]
  spec.email         = ["gaurav@ggvaidya.com"]
  spec.description   = %q{Find the BibTeX information when your citation has an identifier}
  spec.summary       = %q{URI to BibTeX lookup gem}
  spec.homepage      = "http://github.com/gaurav/biburi"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~>1.3.5"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency "coveralls", "~> 0.7.0"

  spec.add_runtime_dependency 'bibtex-ruby', '~> 2.3.4'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6.0'
end
