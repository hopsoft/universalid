# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

task default: :test

Minitest::TestTask.create(:test) do |t|
  t.test_globs = "test/**/*_test.rb"
end
