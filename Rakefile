# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"
require "yard"

Rake::TestTask.new do |task|
  task.test_files = FileList["test/**/*_test.rb"]
end

RuboCop::RakeTask.new

namespace :docs do
  desc "Generate documentation"
  YARD::Rake::YardocTask.new :generate
  CLOBBER << "doc/"

  desc "Check relative links in documentation"
  task :check do
    abort "Incorrect relative links" unless File.read("doc/file.README.html").include?('href="file.LICENSE.html"')
  end
end

task docs: ["docs:generate", "docs:check"]

task default: [:docs, :rubocop, :test]
