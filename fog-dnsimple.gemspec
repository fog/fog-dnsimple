lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fog/dnsimple/version'

Gem::Specification.new do |spec|
  spec.name          = "fog-dnsimple"
  spec.version       = Fog::Dnsimple::VERSION
  spec.authors       = ["Simone Carletti"]
  spec.email         = ["weppos@weppos.net"]

  spec.summary       = %q{Module for the 'fog' gem to support DNSimple.}
  spec.description   = %q{This library can be used as a module for `fog` or as standalone provider
                        to use the DNSimple in applications.}
  spec.homepage      = "https://github.com/fog/fog-dnsimple"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.1"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"

  spec.add_dependency "fog-core", ">= 1.38", "< 3"
  spec.add_dependency "fog-json"
end
