# frozen_string_literal: true

require "date"
require "bigdecimal"
require_relative "../test_helper"

module UniversalID::MessagePackTypes
  class RubyTest < ActiveSupport::TestCase
    SCALARS = {
      Complex: Complex(1, 2),
      Date: Date.today,
      DateTime: DateTime.now,
      FalseClass: false,
      Float: 123.45,
      Integer: 123,
      NilClass: nil,
      Range: 1..10,
      Rational: Rational(3, 4),
      Regexp: /abc/,
      String: "hello",
      Symbol: :symbol,
      Time: Time.now,
      TrueClass: true
    }

    PrimitiveStruct = Struct.new(*SCALARS.keys)

    def test_array
      expected = SCALARS.values
      actual = MessagePack.unpack(MessagePack.pack(expected))
      assert_equal expected, actual
    end

    def test_hash_with_symbol_keys
      expected = SCALARS
      actual = MessagePack.unpack(MessagePack.pack(expected))
      assert_equal expected, actual
    end

    def test_hash_with_integer_keys
      expected = SCALARS.values.each_with_index.to_h { |value, index| [index, value] }
      actual = MessagePack.unpack(MessagePack.pack(expected))
      assert_equal expected, actual
    end

    def test_hash_with_string_keys
      expected = SCALARS.deep_symbolize_keys
      actual = MessagePack.unpack(MessagePack.pack(expected))
      assert_equal expected, actual
    end

    def test_struct
      expected = PrimitiveStruct.new(*SCALARS.values)
      actual = MessagePack.unpack(MessagePack.pack(expected))
      assert_equal expected, actual
    end

    def test_open_struct
      expected = OpenStruct.new(SCALARS)
      actual = MessagePack.unpack(MessagePack.pack(expected))
      assert_equal expected, actual
    end

    def test_set
      expected = Set.new(SCALARS.values)
      actual = MessagePack.unpack(MessagePack.pack(expected))
      assert_equal expected, actual
    end
  end
end
