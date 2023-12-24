# frozen_string_literal: true

require_relative "writer"

module Runner
  include Writer

  WIDTH = 52

  def run(label, &block)
    @time = nil
    GC.disable

    calculation_labels = [
      style("Avg sec/iteration", :darkcyan, :faint, width: WIDTH, pad: "."),
      style("Avg ms/iteration", :darkcyan, width: WIDTH, pad: "."),
      style("Avg sec/record", :darkcyan, :faint, width: WIDTH, pad: "."),
      style("Avg ms/record", :darkcyan, width: WIDTH, pad: ".")
    ]

    Benchmark.benchmark(Benchmark::CAPTION, WIDTH, Benchmark::FORMAT, *calculation_labels) do |x|
      @time = x.report(style(label, width: WIDTH)) { ITERATIONS.times { yield } }

      # iteration calculations...
      avg_secs_per_iteration = @time / ITERATIONS
      avg_ms_per_iteration = avg_secs_per_iteration * 1_000

      # record calculations...
      avg_secs_per_record = @time / MAX_RECORD_COUNT
      avg_ms_per_record = avg_secs_per_record * 1_000

      # calculations...
      [
        avg_secs_per_iteration,
        avg_ms_per_iteration,
        avg_secs_per_record,
        avg_ms_per_record
      ]
    end

    @time
  ensure
    GC.enable
  end
end
