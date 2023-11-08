# frozen_string_literal: true

require_relative "../../test_helper"

class URI::UID::ScalarsTest < Minitest::Test
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
    define_method :"test_#{klass.name}_with_factory" do
      value = SCALARS[klass]
      uid = URI::UID.create(value, without: :prepack)
      assert uid.valid?
      decoded = URI::UID.parse(uid.to_s).decode
      if value.nil?
        assert_nil decoded
      else
        assert_equal value, decoded
      end
    end

    define_method :"test_#{klass.name}_with_factory_pool" do
      value = SCALARS[klass]
      uid = URI::UID.create(value, without: :prepack)
      assert uid.valid?
      decoded = URI::UID.parse(uid.to_s).decode

      if value.nil?
        assert_nil decoded
      else
        assert_equal value, decoded
      end
    end
  end
end
