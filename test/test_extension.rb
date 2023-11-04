# frozen_string_literal: true

class Minitest::Test
  @@active_record_instance = nil

  def initialize(...)
    super(...)
    return if @@active_record_instance

    time = Benchmark.measure do
      with_persisted_campaign do |campaign|
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

  def with_persisted_campaign
    campaign = Campaign.create!(name: Faker::Movie.title)
    yield campaign
  ensure
    campaign&.destroy
  end

  def with_new_campaign
    yield Campaign.new(name: Faker::Movie.title)
  end

  alias_method :original_run, :run

  def run
    result = nil
    time = Benchmark.measure { result = original_run }
    time = time.real.round(5)

    message = "  #{Rainbow("⬇").dimgray.faint} "
    message << Rainbow("Benchmark ").dimgray
    message << if time >= 0.003
      Rainbow("#{"%.5f" % time}s ").red
    elsif time >= 0.001
      Rainbow("#{"%.5f" % time}s ").yellow
    else
      Rainbow("#{"%.5f" % time}s ").green
    end
    message << Rainbow("".ljust(55, ".")).dimgray.faint
    puts message

    result
  end
end
