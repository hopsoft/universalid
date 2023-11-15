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
require "rainbow"
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
    "lib/universal_id/message_pack/types", # coverage doesn't work on these
    "lib/universal_id/message_pack_types", # coverage not needed
    "lib/universal_id/refinements", # coverage doesn't work on these
    "test" # coverage not wanted
  ]
end

# Load UniversalID
require "universal_id"

# Load contribs
require "universal_id/contrib/rails"

if ENV["BENCHMARK_PREPACK"]
  class PrepackObserver
    class << self
      def log_prepack_event(event, object, prepacked = nil)
        case event
        when :before
          object.instance_variable_set(:@_uid_prepack_start, Time.now) unless object.frozen?
          puts Rainbow("\n#{event} #{object.class.name}#prepack".ljust(80, "=")).cyan.bright
          ap object
        when :after
          start = object.remove_instance_variable(:@_uid_prepack_start) if object.instance_variable_defined?(:@_uid_prepack_start)
          time = (Time.now - start).real.round(5) if start
          print Rainbow("#{event} #{object.class.name}#prepack").cyan
          print Rainbow("(#{"%1.3f sec" % time})").cyan + Rainbow("(#{"%6.2fms" % (time * 1_000)})").cyan.bright if time
          puts
          ap prepacked
        end
      end
    end
  end

  UniversalID::Prepacker.add_observer PrepackObserver, :log_prepack_event
end
