# frozen_string_literal: true

require "nokogiri"
require "uri"

require_relative "relative_markdown_links/version"

module YARD # rubocop:disable Style/Documentation
  # GitHub and YARD render Markdown files differently. In particular, relative
  # links between Markdown files that work in GitHub don't work in YARD.
  # For example, if you have `[hello](FOO.md)` in your README, YARD renders it
  # as `<a href="FOO_md.html">hello</a>`, creating a broken link in your docs.
  #
  # With this plugin enabled, you'll get `<a href="file.FOO.html">hello</a>`
  # instead, which correctly links through to the rendered HTML file.
  module RelativeMarkdownLinks
    # Resolves relative links from Markdown files.
    # @param [String] text the HTML fragment in which to resolve links.
    # @return [String] HTML with relative links to extra files converted to `{file:}` links.
    def resolve_links(text)
      return super unless options.files

      filenames = options.files.to_set(&:filename)

      rdoc_filenames = filenames.filter_map { |filename|
        # https://github.com/ruby/rdoc/blob/0e060c69f51ec4a877e5cde69b31d47eaeb2a2b9/lib/rdoc/markup/to_html.rb#L364-L366
        match = %r{\A(?<dirname>(?:[^/#]*/)*+)(?<basename>[^/#]+)\.(?<ext>rb|rdoc|md)\z}i.match(filename)
        next unless match

        ["#{match[:dirname]}#{match[:basename].tr('.', '_')}_#{match[:ext]}.html", filename]
      }.to_h

      html = Nokogiri::HTML.fragment(text)

      html.css("a[href]").each do |link|
        href = URI(link["href"])
        next unless href.relative?

        # Try exact match (e.g., README.md linking to docs/USER_GUIDE.md)
        if filenames.include?(href.path)
          link.replace "{file:#{href} #{link.inner_html}}"
          next
        end

        # Try resolving relative to current file's directory
        if defined?(@file) && @file
          current_dir = File.dirname(@file.filename)
          resolved_path = File.join(current_dir, href.path)

          # Check if this resolves to a known file
          if filenames.include?(resolved_path)
            href.path = resolved_path
            link.replace "{file:#{href} #{link.inner_html}}"
            next
          end

          # Check if this resolves to a known RDoc-style file
          if rdoc_filenames[resolved_path]
            href.path = rdoc_filenames[resolved_path]
            link.replace "{file:#{href} #{link.inner_html}}"
            next
          end
        end

        # Try exact RDoc-style match
        href.path = rdoc_filenames[href.path]
        next unless href.path && filenames.include?(href.path)

        link.replace "{file:#{href} #{link.inner_html}}"
      end

      super(html.to_s)
    end
  end

  Templates::Template.extra_includes << RelativeMarkdownLinks
end
