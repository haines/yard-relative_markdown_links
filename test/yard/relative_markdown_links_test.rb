# frozen_string_literal: true

require_relative "../test_helper"

module YARD
  class RelativeMarkdownLinksTest < Minitest::Test
    def setup
      @template = Class.new {
        include YARD::Templates::Helpers::MarkupHelper
        prepend YARD::RelativeMarkdownLinks

        def resolve_links(text)
          text
        end

        def options
          file = Struct.new(:filename)

          Struct.new(:files).new(
            [
              file.new("world.md"),
              file.new("planet.yaml")
            ]
          )
        end
      }.new

      clean
    end

    def teardown
      clean
    end

    def clean
      FileUtils.rm_rf([".yardoc", "doc"].map { |path| File.expand_path("files/#{path}", __dir__) })
    end

    def test_relative_markdown_links
      input = <<~HTML
        <p>Hello, <a href="world.md">World</a></p>
      HTML

      expected_output = <<~HTML
        <p>Hello, {file:world.md World}</p>
      HTML

      assert_equal expected_output, @template.resolve_links(input)
    end

    def test_relative_markdown_links_from_rdoc
      input = <<~HTML
        <p>Hello, <a href="world_md.html">World</a></p>
      HTML

      expected_output = <<~HTML
        <p>Hello, {file:world.md World}</p>
      HTML

      assert_equal expected_output, @template.resolve_links(input)
    end

    def test_relative_nonmarkdown_links
      input = <<~HTML
        <p>Hello, <a href="planet.yaml">Planet</a></p>
      HTML

      expected_output = <<~HTML
        <p>Hello, {file:planet.yaml Planet}</p>
      HTML

      assert_equal expected_output, @template.resolve_links(input)
    end

    def test_relative_links_to_unincluded_files
      input = <<~HTML
        <p>Hello, <a href="moon.md">Moon</a></p>
      HTML

      assert_equal input, @template.resolve_links(input)
    end

    def test_absolute_markdown_links
      input = <<~HTML
        <p>Hello, <a href="https://github.com/haines/yard-relative_markdown_links/blob/main/README.md">World</a></p>
      HTML

      assert_equal input, @template.resolve_links(input)
    end

    def test_acceptance
      bundle = File.expand_path("../../bin/bundle", __dir__)
      files = File.expand_path("files", __dir__)

      output, status = Open3.capture2e(
        bundle, "exec", "yard",
        "--plugin", "relative_markdown_links",
        "--markup", "markdown",
        "-",
        "*.md",
        chdir: files
      )

      flunk "YARD exited with status #{status.exitstatus}\n#{output}" unless status.success?

      assert_includes File.read(File.expand_path("doc/file.1.html", files)), <<~HTML.chomp
        <a href="file.2.html" title="Hello">Hello</a>
      HTML
    end
  end
end
