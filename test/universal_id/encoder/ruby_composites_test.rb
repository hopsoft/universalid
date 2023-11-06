# frozen_string_literal: true

require_relative "../../test_helper"

class UniversalID::Encoder::RubyCompositesTest < Minitest::Test
  SCALARS = {
    complex: Complex(1, 2),
    date: Date.today,
    datetime: DateTime.now,
    false_class: false,
    float: 123.45,
    integer: 123,
    nil_class: nil,
    range: 1..100,
    rational: Rational(3, 4),
    regexp: /abc/,
    string: "hello",
    symbol: :symbol,
    time: Time.now,
    true_class: true
  }

  NamedStruct = Struct.new(*SCALARS.keys)

  COMPOSITES = {
    Array => SCALARS.values,
    Hash => SCALARS,
    Struct => NamedStruct.new(*SCALARS.values),
    OpenStruct => OpenStruct.new(SCALARS),
    Set => Set.new(SCALARS.values)
  }

  COMPOSITES.each do |klass, value|
    define_method :"test_#{klass.name}" do
      value = COMPOSITES[klass]
      encoded = UniversalID::Encoder.encode(value, prepack: false)
      decoded = UniversalID::Encoder.decode(encoded)
      assert_equal value, decoded
    end
  end
end
