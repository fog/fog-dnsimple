# frozen_string_literal: true

require_relative "lib/fog/dnsimple/version"

Gem::Specification.new do |s|
  s.name = "fog-dnsimple"
  s.version = Fog::Dnsimple::VERSION
  s.authors = ["Simone Carletti"]
  s.email = ["weppos@weppos.net"]

  s.summary = "Module for the 'fog' gem to support DNSimple."
  s.description = "This library can be used as a module for `fog` or as standalone provider to use the DNSimple in applications."
  s.homepage = "https://github.com/fog/fog-dnsimple"
  s.licenses = ["MIT"]
  s.required_ruby_version = ">= 3.2"

  s.metadata = {
    "bug_tracker_uri" => "https://github.com/fog/fog-dnsimple/issues",
    "changelog_uri" => "https://github.com/fog/fog-dnsimple/blob/main/CHANGELOG.md",
    "documentation_uri" => "https://rubydoc.info/gems/#{s.name}/#{s.version}",
    "homepage_uri" => s.homepage,
    "source_code_uri" => "https://github.com/fog/fog-dnsimple/tree/v#{s.version}",
  }

  s.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[
          bin/
          test/
          .git
          Rakefile
      ])
    end
  end
  s.require_paths = ["lib"]
  s.extra_rdoc_files = %w( LICENSE.txt )

  s.add_dependency "dnsimple", "~> 13.0"
  s.add_dependency "fog-core", "~> 2.5"
end
