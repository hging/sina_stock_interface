# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sina_stock_interface/version'

Gem::Specification.new do |spec|
  spec.name          = "sina_stock_interface"
  spec.version       = SinaStockInterface::VERSION
  spec.authors       = ["hging"]
  spec.email         = ["hging3@gmail.com"]
  spec.summary       = %q{get stock info and data by this gem.}
  spec.description   = %q{get stock info and data by this gem.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
