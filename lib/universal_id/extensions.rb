# frozen_string_literal: true

module UniversalID::Extensions; end
path = File.join(File.dirname(__FILE__), "extensions", "**", "*.rb")
Dir.glob(path).each { |file| require file }
