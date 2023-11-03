# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

task default: :test

Minitest::TestTask.create(:test) do |t|
  globs = []
  args = ARGV[1..] || []
  ARGV.replace([ARGV[0]]) # Reset arguments to prevent rake from processing them further

  puts "Args #{args.inspect}"
  globs = args.each_with_object([]) do |arg, memo|
    if arg.start_with?("test/") && arg.end_with?(".rb")
      memo << arg
      next
    end

    if arg.end_with?("_test.rb")
      memo << "test/**/*#{arg}"
      next
    end

    if arg.end_with?("_test")
      memo << "test/**/*#{arg}.rb"
      next
    end

    memo << "test/**/*#{arg}*_test.rb"
  end

  puts "Globs before filtering #{globs.inspect}"
  globs.keep_if { |glob| Dir.glob(glob).any? }
  globs << "test/**/*_test.rb" if args.none? && globs.none?

  if globs.empty?
    puts "No tests found for #{args.inspect}"
    exit 1
  else
    t.test_globs = globs
  end
end
