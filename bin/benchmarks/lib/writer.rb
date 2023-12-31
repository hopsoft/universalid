# frozen_string_literal: true

module Writer
  extend self
  include ActionView::Helpers::NumberHelper

  LINE_WIDTH = 95
  LABEL_WIDTH = 50
  MOVE_UP = "\e[A"
  REPLACE = "\e[K"

  def puts(value = nil, *styles, line: nil, replace: false)
    $stdout.puts "#{MOVE_UP}#{REPLACE}" if replace
    $stdout.puts style(value, *styles, line: line)
  end

  def print(value = nil, *styles, line: nil, replace: false)
    $stdout.puts "#{MOVE_UP}#{REPLACE}" if replace
    $stdout.print style(value, *styles, line: line)
  end

  def style(value, *styles, line: nil, width: LINE_WIDTH)
    styled = Rainbow(value.to_s)
    styles.each { |modifier| styled = styled.public_send(modifier) }
    styled += line(*styles, char: line, head: " ", width: width - value.to_s.length) if line
    styled
  end

  def line(*styles, char: "–", head: "", tail: "", width: LINE_WIDTH)
    style "#{head}#{"".ljust width.floor - head.length - tail.length, char}#{tail}", *(styles - [:bright] + [:faint])
  end
end
