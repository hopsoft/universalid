# frozen_string_literal: true

require_relative "writer"

class Runner
  extend Writer
  include Writer

  ITERATIONS = (ARGV[1] || 200).to_i
  MAX_RECORD_COUNT = (ARGV[2] || 500).to_i

  class << self
    # Returns the object to be serialized in benchmarks
    def subject
      return @subject if @subject

      @subject = begin
        done = false
        increment_record_count

        model = Campaign.create_for_test do |campaign|
          emails = Email.create_for_test(MAX_RECORD_COUNT / 4, campaign: campaign) { increment_record_count }

          emails.each do |email|
            break if done
            rand(2..8).times do
              done = increment_record_count > MAX_RECORD_COUNT
              break if done
              Attachment.create_for_test email: email
            end
          end
        end

        # load associations into memory so they can be included during serialization...
        model.tap { |m| m.emails.each { |e| e.attachments.load } }
      end
    end

    private

    def increment_record_count
      @record_count ||= 0
      puts if @record_count == 0
      print "#{style "Creating", :cyan} #{style @record_count, :lime} #{style "ActiveRecord models", :cyan}#{style "...", :cyan, :faint} ", replace: true
      @record_count += 1
    end
  end

  delegate :subject, to: :"self.class"
  attr_reader :options, :payload

  def initialize(name, description, **options)
    self.class.subject # ensure subject is loaded

    @options = options

    puts style("performing ", :cyan) + style(number_with_delimiter(ITERATIONS), :lime) + style(" iterations", :cyan) + style("...", :cyan, :faint)
    puts
    puts name, :cyan, :bright, line: true
    puts
    puts description.strip, :slategray
  end

  def run_dump(label, &block)
    puts
    puts label, :lime, line: true
    benchmark = run(&block)
    control = Benchmark.measure { ITERATIONS.times { @control_payload ||= instance_exec(&options[:dump]) } }
    puts line, :darkslategray
    puts_comparison benchmark, control
    puts_control control, @control_payload
  end

  def run_load(label, &block)
    puts
    puts label, :lime, line: true
    benchmark = run(&block)
    control = with_payload(@control_payload) { Benchmark.measure { ITERATIONS.times { instance_exec(&options[:load]) } } }
    puts line, :darkslategray
    puts_comparison benchmark, control
    puts_control control, @control_payload
  end

  private

  def run(&block)
    GC.disable

    execution_time = nil

    label = style("Benchmark", :cyan, :bright, line: true, width: Writer::LABEL_WIDTH)

    # setup calculation labels...
    calculation_labels = [
      # style("Avg secs/iteration", :cyan, line: true, width: Writer::LABEL_WIDTH),
      style("Avg ms/iteration", :cyan, line: true, width: Writer::LABEL_WIDTH),
      # style("Avg secs/record", :cyan, line: true, width: Writer::LABEL_WIDTH),
      style("Avg ms/record", :cyan, line: true, width: Writer::LABEL_WIDTH)
    ]

    # execute the benchmark...
    Benchmark.benchmark(Benchmark::CAPTION, Writer::LABEL_WIDTH, Benchmark::FORMAT, *calculation_labels) do |x|
      execution_time = x.report(label) { ITERATIONS.times { @payload ||= instance_exec(&block) } }

      # iteration calculations...
      avg_secs_per_iteration = execution_time / ITERATIONS
      avg_ms_per_iteration = avg_secs_per_iteration * 1_000

      # record calculations...
      avg_secs_per_record = avg_secs_per_iteration / MAX_RECORD_COUNT
      avg_ms_per_record = avg_secs_per_record * 1_000

      # all calculations...
      [
        # avg_secs_per_iteration,
        avg_ms_per_iteration,
        # avg_secs_per_record,
        avg_ms_per_record
      ]
    end

    execution_time
  ensure
    GC.enable
  end

  def with_payload(value)
    original = payload
    @payload = value
    yield
  ensure
    @payload = original
  end
end
