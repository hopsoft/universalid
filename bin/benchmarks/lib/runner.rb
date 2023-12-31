# frozen_string_literal: true

require_relative "writer"

class Runner
  extend Writer
  include Writer

  ITERATIONS = (ARGV[1] || 100).to_i
  MAX_RECORD_COUNT = (ARGV[2] || 500).to_i

  class << self
    # Returns the object to be serialized in benchmarks
    def record
      return @record if @record

      @record = begin
        email_count = (MAX_RECORD_COUNT / 4.to_f).round
        attachment_count = ((MAX_RECORD_COUNT - email_count) / email_count.to_f).round

        campaign = Campaign.create_for_test(emails: email_count, attachments: attachment_count)

        # load associations into memory so they can be included during serialization...
        campaign.tap { |c| c.emails.each { |c| c.attachments.load } }
      end
    end
  end

  def initialize(desc:, subject: self.class.record)
    @subject = subject

    # setup...
    self.class.record # ensure record is loaded

    # header...
    caller_path = caller(1..1).first.split(":").first.split("universalid").last
    puts
    puts
    puts line(:lime, :faint, char: "▓")
    print line(:lime, :faint, char: "▓", tail: " ", width: 3)
    print style(caller_path, :lime, :bright)
    puts line(:lime, :faint, char: "▓", head: " ", width: Writer::LINE_WIDTH - caller_path.size - 3)
    puts

    # description...
    puts desc, :slategray

    # iterations...
    print style("   Performing ", :magenta) + style(number_with_delimiter(ITERATIONS), :lime) + style(" iterations", :magenta) + style("...", :magenta, :faint)

    # subject...
    record_count = 1 + subject.emails.size + subject.emails.map(&:attachments).flatten.size if subject.is_a?(Campaign)
    print " with #{subject.class.name}", :magenta, :bright
    print style " (", :lime, :faint
    print style "#{number_with_delimiter(record_count)} records", :lime if record_count
    puts style ")", :lime, :faint
    puts
  end

  attr_reader(
    :payload, # ....................serialized payload from the benchmark
    :payload_restored, # ...........deserialized object from the benchmark's serialized payload
    :control_dump_label, # .........label for control serialization
    :control_dump_proc, # ..........proc used for control serialization
    :control_load_label, # .........label for control deserialization
    :control_load_proc, # ..........proc used for control deserialization
    :control_payload, # ............serialized payload from the control
    :control_payload_restored, # ...deserialized object from the control's serialized payload
    :subject # .....................the object to be serialized/deserialized in the benchmark
  )

  def control_dump(label, &block)
    @control_dump_label = label
    @control_dump_proc = block
  end

  def control_load(label, &block)
    @control_load_label = label
    @control_load_proc = block
  end

  def run_dump(label, &block)
    print line(:lime, char: "–", tail: " ", width: 3)
    print label, :lime
    puts line(:lime, char: "–", head: " ", width: Writer::LINE_WIDTH - label.size - 3)

    @payload = instance_exec(&block)
    benchmark = run(&block)

    @control_payload = instance_exec(&control_dump_proc)
    control = Benchmark.measure { ITERATIONS.times { instance_exec(&control_dump_proc) } }

    puts_comparison benchmark, control, payload, control_payload
    puts_control control_dump_label, control, payload, control_payload
  end

  def run_load(label, &block)
    puts
    print line(:lime, char: "–", tail: " ", width: 3)
    print label, :lime
    puts line(:lime, char: "–", head: " ", width: Writer::LINE_WIDTH - label.size - 3)

    @payload_restored = instance_exec(&block)
    benchmark = run(&block)

    control = with_payload @control_payload do
      @control_payload_restored = instance_exec(&control_load_proc)
      Benchmark.measure { ITERATIONS.times { instance_exec(&control_load_proc) } }
    end

    puts_comparison benchmark, control, payload_restored, control_payload_restored, equivalence: true
    puts_control control_load_label, control, payload_restored, control_payload_restored, equivalence: true
  end

  private

  def run(&block)
    # GC.disable

    execution_time = nil

    label = style("   Benchmark", :cyan, :bright, line: "·", width: Writer::LABEL_WIDTH)

    # setup calculation labels...
    calculation_labels = [
      style("   Avg secs/iteration", :cyan, line: "·", width: Writer::LABEL_WIDTH),
      style("   Avg ms/iteration", :cyan, line: "·", width: Writer::LABEL_WIDTH)
      # style("   Avg secs/record", :cyan, line: "·", width: Writer::LABEL_WIDTH),
      # style("   Avg ms/record", :cyan, line: "·", width: Writer::LABEL_WIDTH)
    ]

    # execute the benchmark...
    Benchmark.benchmark(Benchmark::CAPTION, Writer::LABEL_WIDTH, Benchmark::FORMAT, *calculation_labels) do |x|
      execution_time = x.report(label) { ITERATIONS.times { instance_exec(&block) } }

      # iteration calculations...
      avg_secs_per_iteration = execution_time / ITERATIONS
      avg_ms_per_iteration = avg_secs_per_iteration * 1_000

      # record calculations...
      # avg_secs_per_record = avg_secs_per_iteration / MAX_RECORD_COUNT
      # avg_ms_per_record = avg_secs_per_record * 1_000

      # all calculations...
      [
        avg_secs_per_iteration,
        avg_ms_per_iteration
        # avg_secs_per_record,
        # avg_ms_per_record
      ]
    end

    execution_time
    # ensure
    # GC.enable
  end

  def with_payload(value)
    original = payload
    @payload = value
    yield
  ensure
    @payload = original
  end

  def difference(value, other)
    return ["(N/A)", 0] if other.zero?

    diff = value.to_r / other.to_r

    label = if diff < 1
      return ["(N/A)", 0] if diff.zero?
      " ⬇︎ (#{number_with_precision 1 / diff, delimiter: ",", precision: 1}x)"
    elsif diff > 1
      " ⬆︎ (#{number_with_precision diff, delimiter: ",", precision: 1}x)"
    else
      ""
    end

    [label, diff]
  end

  def puts_control(label, control, object, control_object, equivalence: false)
    puts
    print "   Control: ", :dimgray
    puts label, :dimgray, :bright

    # type...
    mismatch = object.instance_of?(control_object.class) ? "" : " (mismatch)"
    prefix = "   Class"
    suffix = control_object.class.name
    print style(prefix, :dimgray) + style(mismatch, :red)
    print line(:dimgray, char: "·", head: " ", tail: " ", width: Writer::LINE_WIDTH - prefix.size - mismatch.size - suffix.size)
    puts suffix

    # equivalence...
    if equivalence
      mismatch = (object == control_object) ? "" : " (mismatch)"
      prefix = "   Equivalent"
      suffix = (object == control_object).to_s
      print style(prefix, :dimgray) + style(mismatch, :red)
      print line(:dimgray, char: "·", head: " ", tail: " ", width: Writer::LINE_WIDTH - prefix.size - mismatch.size - suffix.size)
      puts suffix
    end

    # size...
    size = control_object.try(:bytesize) || ObjectSpace.try(:memsize_of, control_object) || 0.0
    prefix = "   Payload Size"
    suffix = number_to_human_size(size).downcase
    print style(prefix, :dimgray)
    print line(:dimgray, char: "·", head: " ", tail: " ", width: Writer::LINE_WIDTH - prefix.size - suffix.size)
    puts suffix

    # performance...
    prefix = "   Benchmark Time"
    suffix = number_to_human(control.real, precision: 2) + " secs"
    print style(prefix, :dimgray)
    print line(:dimgray, char: "·", head: " ", tail: " ", width: Writer::LINE_WIDTH - prefix.size - suffix.size)
    puts suffix
  end

  def puts_comparison(benchmark, control, object, control_object, equivalence: false)
    # type...
    mismatch = object.instance_of?(control_object.class) ? "" : " (mismatch)"
    prefix = "   Class"
    suffix = object.class.name
    print style(prefix, :darkcyan, :bright) + style(mismatch, :red)
    print line(:darkcyan, char: "·", head: " ", tail: " ", width: Writer::LINE_WIDTH - prefix.size - mismatch.size - suffix.size)
    puts suffix

    # equivalence...
    if equivalence
      mismatch = (object == control_object) ? "" : " (mismatch)"
      prefix = "   Equivalent"
      suffix = (object == control_object).to_s
      print style(prefix, :darkcyan) + style(mismatch, :red)
      print line(:darkcyan, char: "·", head: " ", tail: " ", width: Writer::LINE_WIDTH - prefix.size - mismatch.size - suffix.size)
      puts suffix
    end

    # size...
    size = object.try(:bytesize) || ObjectSpace.try(:memsize_of, object) || 0.0
    control_size = control_object.try(:bytesize) || ObjectSpace.try(:memsize_of, control_object) || 0.0
    diff, ratio = difference(size, control_size)
    prefix = "   Size"
    suffix = number_to_human_size(size, precision: 1).downcase
    print style(prefix, :darkcyan, :bright) + style(diff, (ratio <= 1) ? :lime : :darkorange)
    print line(:darkcyan, char: "·", head: " ", tail: " ", width: Writer::LINE_WIDTH - prefix.size - diff.size - suffix.size + (diff.size.zero? ? 0 : 1))
    puts suffix

    # performance...
    diff, ratio = difference(benchmark.real, control.real)
    prefix = "   Benchmark Time"
    suffix = number_to_human(benchmark.real, precision: 2) + " secs"
    print style(prefix, :darkcyan, :bright) + style(diff, (ratio <= 1) ? :lime : :darkorange)
    print line(:darkcyan, char: "·", head: " ", tail: " ", width: Writer::LINE_WIDTH - prefix.size - diff.size - suffix.size + 1)
    puts suffix
  end
end
