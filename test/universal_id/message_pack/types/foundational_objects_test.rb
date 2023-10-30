# frozen_string_literal: true

require "date"
require "bigdecimal"
require_relative "../../test_helper"

module UniversalID::MessagePack::Types
  class FoundationalObjectsTest < ActiveSupport::TestCase
    PRIMITIVES = {
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

    PrimitiveStruct = Struct.new(*PRIMITIVES.keys)

    def test_array_with_primitive_values
      expected = PRIMITIVES.values
      actual = MessagePack.unpack(MessagePack.pack(expected))
      assert_equal expected, actual
    end

    def test_hash_with_symbol_keys
      expected = PRIMITIVES
      actual = MessagePack.unpack(MessagePack.pack(expected))
      assert_equal expected, actual
    end

    def test_hash_with_integer_keys
      expected = PRIMITIVES.values.each_with_index.to_h { |value, index| [index, value] }
      actual = MessagePack.unpack(MessagePack.pack(expected))
      assert_equal expected, actual
    end

    def test_hash_with_string_keys
      expected = PRIMITIVES.deep_symbolize_keys
      actual = MessagePack.unpack(MessagePack.pack(expected))
      assert_equal expected, actual
    end

    def test_struct
      expected = PrimitiveStruct.new(*PRIMITIVES.values)
      actual = MessagePack.unpack(MessagePack.pack(expected))
      assert_equal expected, actual
    end

    def test_open_struct
      expected = OpenStruct.new(PRIMITIVES)
      actual = MessagePack.unpack(MessagePack.pack(expected))
      assert_equal expected, actual
    end

    def test_set
      expected = Set.new(PRIMITIVES.values)
      actual = MessagePack.unpack(MessagePack.pack(expected))
      assert_equal expected, actual
    end
  end
end
