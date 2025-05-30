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

  spec.files = Dir[
    "lib/**/*.rb",
    ".yardopts",
    "CHANGELOG.md",
    "CODE_OF_CONDUCT.md",
    "LICENSE.md",
    "README.md",
    "yard-relative_markdown_links.gemspec"
  ]

  spec.require_paths = ["lib"]

  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://haines.github.io/yard-relative_markdown_links/"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["yard.run"] = "yri"

  spec.required_ruby_version = ">= 3.2"

  spec.add_dependency "nokogiri", ">= 1.14.3", "< 2"
end
