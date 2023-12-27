# frozen_string_literal: true

module Writer
  extend self
  include ActionView::Helpers::NumberHelper

  LINE_WIDTH = 80
  LABEL_WIDTH = 35
  MOVE_UP = "\e[A"
  REPLACE = "\e[K"

  def puts(value = nil, *styles, line: false, replace: false)
    $stdout.puts "#{MOVE_UP}#{REPLACE}" if replace
    $stdout.puts style(value, *styles, line: line)
  end

  def print(value = nil, *styles, line: false, replace: false)
    $stdout.puts "#{MOVE_UP}#{REPLACE}" if replace
    $stdout.print style(value, *styles, line: line)
  end

  def style(value, *styles, line: false, width: LINE_WIDTH)
    styled = Rainbow(value.to_s)
    styles.each { |modifier| styled = styled.public_send(modifier) }
    styled += line(*styles, width: width - value.to_s.length) if line
    styled
  end

  def line(*styles, width: LINE_WIDTH)
    style "".ljust(width, "–"), *(styles - [:bright] + [:faint])
  end

  def puts_control(benchmark, payload)
    prefix = "Control"
    suffix = benchmark.to_s.strip
    puts style(prefix, :blueviolet) + line(:blueviolet, width: Writer::LINE_WIDTH - prefix.size - suffix.size) + style(suffix, :blueviolet)

    prefix = "Payload size"
    suffix = number_to_human_size(payload.bytesize)
    puts style(prefix, :blueviolet) + line(:blueviolet, width: Writer::LINE_WIDTH - prefix.size - suffix.size) + style(suffix, :blueviolet)
  end

  def puts_comparison(benchmark, control)
    prefix = "Benchmark"
    suffix = benchmark.to_s.strip
    diff, ratio = difference(benchmark.real, control.real)
    puts style(prefix, :darkcyan, :bright) + " " + style(diff, (ratio <= 1) ? :lime : :orange) + line(:darkcyan, width: Writer::LINE_WIDTH - prefix.size - diff.size - suffix.size - 1) + style(suffix, :darkcyan)

    prefix = "Payload size"
    payload = number_to_human_size(@payload.bytesize)
    diff, ratio = difference(@payload.bytesize, @control_payload.bytesize)
    puts style(prefix, :darkcyan, :bright) + " " + style(diff, (ratio <= 1) ? :lime : :orange) + line(:darkcyan, width: Writer::LINE_WIDTH - prefix.size - payload.size - diff.size - 1) + style(payload, :darkcyan)
  end

  private

  def difference(value, other)
    diff = value.to_f / other.to_f

    label = if diff < 1
      "(#{number_with_precision 1 / diff, delimiter: ",", precision: 1}x better)"
    elsif diff > 1
      "(#{number_with_precision diff, delimiter: ",", precision: 1}x worse)"
    else
      "(#{number_with_precision diff, delimiter: ",", precision: 1}x equal)"
    end

    [label, diff]

    # return [sprintf("(%.1fx better)", 1 / diff), diff] if diff < 1
    # return [sprintf("(%.1fx worse)", diff), diff] if diff > 1
    # [sprintf("(%.1fx equal)", diff), diff]
  end
end
