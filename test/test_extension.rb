# frozen_string_literal: true

class Minitest::Test
  @@active_record_instance = nil

  def initialize(...)
    super(...)
    return if @@active_record_instance

    time = Benchmark.measure do
      Campaign.create_for_test do |campaign|
        self.class.class_variable_set(:@@active_record_instance, campaign)
      end
    end

    time = time.real.round(5)
    message = Rainbow("Flex ActiveRecord before run to prevent skewing individual test benchmarks (").yellow
    message << Rainbow("#{"%.5f" % time}s").yellow.bright
    message << Rainbow(")").yellow
    puts message
    puts
  end

  alias_method :original_run, :run

  def run
    result = nil
    time = Benchmark.measure { result = original_run }
    time = time.real.round(5)
    time_in_ms = time * 1000

    message = "  #{Rainbow("⬇").dimgray.faint} "
    message << Rainbow("Benchmark ").dimgray
    message << if time >= 0.03
      Rainbow("> 30ms ").red.faint + Rainbow("(#{"%6.2fms" % time_in_ms})").red.bright
    elsif time > 0.01
      Rainbow("< 30ms ").yellow.faint + Rainbow("(#{"%6.2fms" % time_in_ms})").yellow.bright
    else
      Rainbow("< 10ms ").green.faint + Rainbow("(#{"%6.2fms" % time_in_ms})").green.bright
    end
    message << Rainbow("".ljust(55, ".")).dimgray.faint
    puts message

    result
  end
end
