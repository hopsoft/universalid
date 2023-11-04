# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "pry"

task default: :test

Minitest::TestTask.create(:test) do |t|
  pattern = ARGV[1]
  ARGV.clear

  globs = if pattern
    pattern.end_with?("_test.rb") ?
      ["test/**/*#{pattern}"] :
      ["test/**/*#{pattern}**/*_test.rb", "test/**/*#{pattern}*_test.rb"]
  else
    ["test/**/*_test.rb"]
  end

  t.test_globs = globs
end
