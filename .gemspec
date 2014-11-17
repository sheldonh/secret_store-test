# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'secret_store/test/version'

Gem::Specification.new do |spec|
  spec.name          = "secret_store-test"
  spec.version       = SecretStore::Test::VERSION
  spec.authors       = ["Sheldon Hearn"]
  spec.email         = ["sheldonh@starjuice.net"]
  spec.summary       = %q{Testing library for the secret store toolkit}
  spec.description   = %q{Testing library for the secret store toolkit}
  spec.homepage      = "https://github.com/sheldonh/secret_store-test"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "cucumber", "~> 1.3"
  spec.add_development_dependency "byebug", "~> 3.5"
end
