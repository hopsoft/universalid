# frozen_string_literal: true

require "active_record"
require "awesome_print"
require "benchmark"
require "bigdecimal"
require "date"
require "etc"
require "faker"
require "globalid"
require "minitest/autorun"
require "minitest/parallel"
require "minitest/reporters"
require "model_probe"
require "simplecov"
require "timecop"

# MiniTest setup
Minitest.parallel_executor = Minitest::Parallel::Executor.new([Etc.nprocessors, 1].max) # thread count
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# TODO: Get coverage working
# Coverage setup
# SimpleCov.start do
#   project_name "UniversalID"
#   add_filter [
#     "lib/universalid/message_pack_types", # ....................coverage doesn't work on these
#     "lib/universalid/extensions/**/*message_pack_type.rb", # ...coverage doesn't work on these
#     "lib/universalid/refinements", # ...........................coverage doesn't work on these
#     "test" # ...................................................coverage not wanted
#   ]
# end

require "universalid"

# Minimal subset of Rails tooling for testing purposes
require_relative "rails_kit/setup"

module UniversalID::MessagePack; end

class Minitest::Test
  alias_method :original_run, :run

  def run
    Campaign.destroy_all
    result = nil
    time = Benchmark.measure { result = original_run }
    time = time.real.round(5)
    time_in_ms = time * 1000

    message = "  #{Rainbow("⬇").dimgray.faint} "
    message << Rainbow("Benchmark ").dimgray
    message << if time >= 0.03
      Rainbow("> 30ms ").red.faint + Rainbow("(#{"%1.3f sec" % time})").red + Rainbow("(#{"%6.2fms" % time_in_ms})").red.bright
    elsif time > 0.01
      Rainbow("< 30ms ").yellow.faint + Rainbow("(#{"%1.3f sec" % time})").yellow + Rainbow("(#{"%6.2fms" % time_in_ms})").yellow.bright
    else
      Rainbow("< 10ms ").green.faint + Rainbow("(#{"%1.3f sec" % time})").green + Rainbow("(#{"%6.2f ms" % time_in_ms})").green.bright
    end
    message << Rainbow("".ljust(55, ".")).dimgray.faint
    puts message

    result
  end

  def self.scalars
    {
      bigdecimal: BigDecimal("123.45"),
      complex: Complex(1, 2),
      date: Date.today,
      datetime: DateTime.now,
      false_class: false,
      float: 123.45,
      integer: 123,
      nil_class: nil,
      range: 1..100,
      rational: Rational(3, 4),
      regexp: /abc/,
      string: "hello",
      symbol: :symbol,
      time: Time.now,
      true_class: true
    }
  end

  def scalars
    self.class.scalars
  end

  def time_with_zones
    month = ActiveSupport::TimeZone["UTC"].now.beginning_of_year

    Timecop.freeze time do
      11.times do |i|
        ActiveSupport::TimeZone.all.each do |time_zone|
          time = month.in_time_zone(time_zone).advance(days: rand(1..28), minutes: rand(1..59))
          yield time
        end

        month.advance months: 1
      end
    end
  end
end
