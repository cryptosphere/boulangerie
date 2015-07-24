# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'boulangerie/version'

Gem::Specification.new do |spec|
  spec.name          = "boulangerie"
  spec.version       = Boulangerie::VERSION
  spec.authors       = ["Tony Arcieri"]
  spec.email         = ["bascule@gmail.com"]
  spec.licenses      = ["MIT"]

  spec.summary       = "An opinionated library for creating and verifying Macaroons in Ruby"
  spec.description   = "Boulangerie provides schemas, creation, and verification for the Macaroons bearer credential format"
  spec.homepage      = "https://github.com/cryptosphere/boulangerie"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "macaroons"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
