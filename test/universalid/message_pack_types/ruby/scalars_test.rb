# frozen_string_literal: true

module UniversalID::MessagePackTypes
  class RubyScalarsTest < Minitest::Test
    SCALARS = {
      BigDecimal => BigDecimal("123.45"),
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
      define_method :"test_#{klass.name}_with_factory" do
        value = SCALARS[klass]
        packed = UniversalID::MessagePackFactory.pack(value)
        unpacked = UniversalID::MessagePackFactory.unpack(packed)

        if value.nil?
          assert_nil unpacked
        else
          assert_equal value, unpacked
        end
      end

      define_method :"test_#{klass.name}_with_factory_pool" do
        value = SCALARS[klass]
        packed = UniversalID::MessagePackFactory.msgpack_pool.dump(value)
        unpacked = UniversalID::MessagePackFactory.msgpack_pool.load(packed)

        if value.nil?
          assert_nil unpacked
        else
          assert_equal value, unpacked
        end
      end
    end
  end
end
