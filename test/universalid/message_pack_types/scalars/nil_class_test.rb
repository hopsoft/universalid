# frozen_string_literal: true

class UniversalID::Packer::NilClassTest < Minitest::Test
  def test_big_decimal
    value = nil
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal 1, packed.size
    assert_equal "\xC0".b, packed
    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::NilClassTest < Minitest::Test
  def test_big_decimal
    value = nil
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal 7, encoded.size
    assert_equal "CwCAwAM", encoded
    assert_equal value, decoded
  end
end

class URI::UID::NilClassTest < Minitest::Test
  def test_big_decimal
    value = nil
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert uri.start_with?("uid://universalid/CwCAwAM")
    assert_equal value, decoded
  end
end
