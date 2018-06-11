# YARD::RelativeMarkdownLinks

[![Docs](https://img.shields.io/badge/docs-github.io-blue.svg?style=flat-square)](https://haines.github.io/yard-relative_markdown_links/)
[![Gem](https://img.shields.io/gem/v/yard-relative_markdown_links.svg?style=flat-square)](https://rubygems.org/gems/yard-relative_markdown_links)
[![GitHub](https://img.shields.io/badge/github-haines%2Fyard--relative__markdown__links-blue.svg?style=flat-square)](https://github.com/haines/yard-relative_markdown_links)
[![License](https://img.shields.io/github/license/haines/yard-relative_markdown_links.svg?style=flat-square)](https://github.com/haines/yard-relative_markdown_links/blob/master/LICENSE.md)
[![Travis](https://img.shields.io/travis/haines/yard-relative_markdown_links.svg?style=flat-square)](https://travis-ci.org/haines/yard-relative_markdown_links)


A [YARD](https://yardoc.org) plugin to allow relative links between Markdown files.

GitHub and YARD render Markdown files differently.
In particular, relative links between Markdown files that work in GitHub don't work in YARD.
For example, if you have `[hello](FOO.md)` in your README, YARD renders it as `<a href="FOO.md">hello</a>`, creating a broken link in your docs.

With this plugin enabled, you'll get `<a href="file.FOO.html">hello</a>` instead, which correctly links through to the rendered HTML file.


## Installation

Add this line to your application's `Gemfile`:

```ruby
gem "yard-relative_markdown_links"
```

And then execute:

```console
$ bundle install
```

Or install it yourself as:

```console
$ gem install yard-relative_markdown_links
```


## Usage

Add this line to your application's `.yardopts`:

```
--plugin relative_markdown_links
```

You'll also need to make sure your Markdown files are processed by YARD.
To include all Markdown files in your project, add the following lines to the end of your application's `.yardopts`:

```
-
**/*.md
```


## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `bin/rake test` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bin/rake install`.
To release a new version, update the version number in `lib/yard/relative_markdown_links/version.rb`, and then run `bin/rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [RubyGems](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome [on GitHub](https://github.com/haines/yard-relative_markdown_links).
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](CODE_OF_CONDUCT.md).


## License

© 2018 Andrew Haines, released under the [MIT license](LICENSE.md).
