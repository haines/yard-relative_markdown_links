# frozen_string_literal: true

require "nokogiri"
require "yard"
require "uri"
require "yard/relative_markdown_links/version"


module YARD # rubocop:disable Style/Documentation
  # GitHub and YARD render Markdown files differently. In particular, relative
  # links between Markdown files that work in GitHub don't work in YARD.
  # For example, if you have `[hello](FOO.md)` in your README, YARD renders it
  # as `<a href="FOO.md">hello</a>`, creating a broken link in your docs.
  #
  # With this plugin enabled, you'll get `<a href="file.FOO.html">hello</a>`
  # instead, which correctly links through to the rendered HTML file.
  module RelativeMarkdownLinks
    # Resolves relative links from Markdown files.
    # @param [String] text the HTML fragment in which to resolve links.
    # @return [String] HTML with relative links to extra files converted to `{file:}` links.
    def resolve_links(text)
      html = Nokogiri::HTML.fragment(text)
      html.css("a[href]").each do |link|
        href = URI(link["href"])

        next unless href.relative? && options.files.map(&:filename).include?(href.path)

        link.replace "{file:#{href} #{link.inner_html}}"
      end
      super(html.to_s)
    end
  end

  Templates::Template.extra_includes << RelativeMarkdownLinks
end
