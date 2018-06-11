# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"
require "yard"

Rake::TestTask.new do |task|
  task.test_files = FileList["test/**/*_test.rb"]
end

RuboCop::RakeTask.new

desc "Generate documentation"
YARD::Rake::YardocTask.new :doc
CLOBBER << "doc/"

task :default => [:doc, :rubocop, :test]
