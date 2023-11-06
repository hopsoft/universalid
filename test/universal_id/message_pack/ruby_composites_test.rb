# frozen_string_literal: true

require_relative "../../test_helper"

class UniversalID::MessagePackRubyCompositesTest < Minitest::Test
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
    define_method :"test_#{klass.name}_with_factory" do
      value = COMPOSITES[klass]
      packed = UniversalID::MessagePackFactory.pack(value)
      unpacked = UniversalID::MessagePackFactory.unpack(packed)
      assert_equal value, unpacked
    end

    define_method :"test_#{klass.name}_with_factory_pool" do
      value = COMPOSITES[klass]
      packed = UniversalID::MessagePackFactoryPool.dump(value)
      unpacked = UniversalID::MessagePackFactoryPool.load(packed)
      assert_equal value, unpacked
    end
  end
end
