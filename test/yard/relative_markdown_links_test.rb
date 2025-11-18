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
              file.new("planet.yaml"),
              file.new("docs/RESOURCES.md"),
              file.new("docs/USER_GUIDE.md")
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

    def test_relative_links_in_subdirectory
      # Simulate being in docs/RESOURCES.md
      file = Struct.new(:filename).new("docs/RESOURCES.md")
      @template.instance_variable_set(:@file, file)

      input = <<~HTML
        <p>Check out the <a href="USER_GUIDE_md.html">User Guide</a></p>
      HTML

      expected_output = <<~HTML
        <p>Check out the {file:docs/USER_GUIDE.md User Guide}</p>
      HTML

      assert_equal expected_output, @template.resolve_links(input)
    end

    def test_ambiguous_filenames_in_different_directories
      # Test that when multiple directories have files with the same name,
      # links are resolved relative to the current file's directory

      template = Class.new {
        include YARD::Templates::Helpers::MarkupHelper
        prepend YARD::RelativeMarkdownLinks

        def resolve_links(text)
          text
        end

        def options
          file = Struct.new(:filename)

          Struct.new(:files).new(
            [
              file.new("docs/GUIDE.md"),
              file.new("guides/GUIDE.md")
            ]
          )
        end
      }.new

      # When in docs/, link to GUIDE.md should resolve to docs/GUIDE.md
      file = Struct.new(:filename).new("docs/README.md")
      template.instance_variable_set(:@file, file)

      input = <<~HTML
        <p>See the <a href="GUIDE_md.html">guide</a></p>
      HTML

      expected_output = <<~HTML
        <p>See the {file:docs/GUIDE.md guide}</p>
      HTML

      assert_equal expected_output, template.resolve_links(input)
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

    def test_acceptance_subdirectory_links
      bundle = File.expand_path("../../bin/bundle", __dir__)
      files = File.expand_path("files", __dir__)

      output, status = Open3.capture2e(
        bundle, "exec", "yard",
        "--plugin", "relative_markdown_links",
        "--markup", "markdown",
        "-",
        "docs/*.md",
        chdir: files
      )

      flunk "YARD exited with status #{status.exitstatus}\n#{output}" unless status.success?

      resources_html = File.read(File.expand_path("doc/file.RESOURCES.html", files))

      # The link from RESOURCES.md to USER_GUIDE.md should be converted to a proper file link
      assert_includes resources_html, '<a href="file.USER_GUIDE.html"',
                      "Expected relative link to be converted to YARD file link"
    end
  end
end
