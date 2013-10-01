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

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-core"
  spec.add_development_dependency "coveralls"
end
