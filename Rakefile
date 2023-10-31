# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

task default: :test

Minitest::TestTask.create(:test) do |t|
  t.test_globs = if ARGV.size > 1
    patterns = ARGV[1..].map { |arg| "test/**/#{arg}*_test.rb" }
    ARGV.replace([ARGV[0]]) # Reset arguments to prevent rake from processing them further
    patterns
  else
    ["test/**/*_test.rb"]
  end
end
