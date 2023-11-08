# frozen_string_literal: true

require_relative "../../test_helper"

class UniversalID::Encoder::ScalarsTest < Minitest::Test
  SCALARS = {
    Complex => Complex(1, 2),
    Date => Date.today,
    DateTime => DateTime.now,
    FalseClass => false,
    Float => 123.45,
    Integer => 123,
    NilClass => nil,
    Range => 1..100,
    Rational => Rational(3, 4),
    Regexp => /abc/,
    String => "hello",
    Symbol => :symbol,
    Time => Time.now,
    TrueClass => true
  }

  SCALARS.each do |klass, value|
    define_method :"test_#{klass.name}" do
      value = SCALARS[klass]
      encoded = UniversalID::Encoder.encode(value)
      decoded = UniversalID::Encoder.decode(encoded)

      if value.nil?
        assert_nil decoded
      else
        assert_equal value, decoded
      end
    end
  end
end
