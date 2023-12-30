# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

# task default: :test

# Minitest::TestTask.create(:test) do |t|
# t.test_globs = ENV["GLOBS"] ? ENV["GLOBS"].split(",") : ["test/**/*_test.rb"]
# end

require "pry-byebug"

task default: :test

# take explicit control of test initialization

task test: [:load_tests, :exec_tests]

task :load_tests do
  require_relative "test/test_extension"
  globs = ENV["GLOBS"] ? ENV["GLOBS"].split(",") : ["test/**/*_test.rb"]
  files = globs.map { |glob| Dir[glob] }.flatten.shuffle
  files.each { |file| require_relative file }
end

Minitest::TestTask.create(:exec_tests) do |t|
  t.test_globs.clear
end
