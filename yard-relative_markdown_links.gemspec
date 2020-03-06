# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "yard/relative_markdown_links/version"

Gem::Specification.new do |spec|
  spec.name = "yard-relative_markdown_links"
  spec.version = YARD::RelativeMarkdownLinks::VERSION
  spec.authors = ["Andrew Haines"]
  spec.email = ["andrew@haines.org.nz"]

  spec.summary = "A YARD plugin to allow relative links between Markdown files"

  spec.homepage = "https://github.com/haines/yard-relative_markdown_links"
  spec.license = "MIT"

  spec.files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0").reject { |path| path.match(%r{^test/}) } }
  spec.require_paths = ["lib"]

  spec.metadata["yard.run"] = "yri"

  spec.add_dependency "nokogiri", "~> 1.8"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "minitest", "~> 5.11"
  spec.add_development_dependency "pry", "~> 0.11"
  spec.add_development_dependency "rake", "~> 12.1"
  spec.add_development_dependency "rubocop", "~> 0.80.1"
  spec.add_development_dependency "yard", "~> 0.9"
end
