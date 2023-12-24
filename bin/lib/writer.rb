# frozen_string_literal: true

module Writer
  WIDTH = 96

  def rewrite(message)
    print "\e[A\e[K"
    puts message
  end

  def write(text, *styles, subtext: nil, width: WIDTH, pad: nil, newline: true)
    puts if newline
    puts style(text, *styles, width: WIDTH, pad: pad)
    if subtext
      extract_lines(subtext, length: width).each { |l| puts style(l.strip, *(styles + [:faint, :italic])) }
      puts style("".ljust(WIDTH + 1, pad), *(styles + [:faint])) if pad
    end
    yield if block_given?
  end

  def compare(label, value, baseline_value, formatted:, baseline_label: "baseline")
    diff = (value.to_f / baseline_value.to_f) * 100
    percentage = number_to_percentage(100 - diff, precision: 2)
    print "#{style label, :faint, width: Runner::WIDTH, pad: "."}  "
    print "#{formatted} ".ljust(10, " ")
    puts (value > baseline_value) ? style("(#{percentage} > #{baseline_label})", :red) : style("(#{percentage} < #{baseline_label})", :green)
  end

  def style(string, *styles, width: WIDTH, pad: nil)
    string = string.to_s
    line = Rainbow("".ljust(width - string.size, pad)).faint if pad
    string = Rainbow(string)

    styles.each do |modifier|
      line = line.public_send(modifier) if line
      string = string.public_send(modifier)
    end

    return string unless line
    "#{string} #{line.faint}"
  end

  private

  def extract_lines(input, length:)
    input = input.to_s.squish
    return [] unless input.size > 0
    input.scan(/\S.{0,#{length - 1}}(?=\s|\n|\z)/)
  end
end
