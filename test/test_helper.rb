# frozen_string_literal: true

require "awesome_print"
require "benchmark"
require "bigdecimal"
require "bundler"
require "date"
require "etc"
require "faker"
require "minitest/autorun"
require "minitest/parallel"
require "minitest/reporters"
require "pry-byebug"
require "pry-doc"
require "simplecov"

# MiniTest setup
Minitest.parallel_executor = Minitest::Parallel::Executor.new([Etc.nprocessors, 1].max) # thread count
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# Bring in a minimal subset of Rails tooling for testing purposes
# - GlobalID (must be loaded before UniversalID to use GID supported features of UID)
# - ActiveRecord
require_relative "rails_kit/setup"
require_relative "test_extension"

SimpleCov.start do
  project_name "UniversalID"
  add_filter [
    "lib/universalid/message_pack/types", # coverage doesn't work on these
    "lib/universalid/message_pack_types", # coverage not needed
    "lib/universalid/refinements", # coverage doesn't work on these
    "test" # coverage not wanted
  ]
end

require "universalid"
