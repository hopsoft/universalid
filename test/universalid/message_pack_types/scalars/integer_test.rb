# frozen_string_literal: true

class UniversalID::Packer::IntegerTest < Minitest::Test
  def test_big_decimal
    value = 758423
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal 5, packed.size
    assert_equal "\xCE\x00\v\x92\x97".b, packed
    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::IntegerTest < Minitest::Test
  def test_big_decimal
    value = 758423
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal 12, encoded.size
    assert_equal "CwKAzgALkpcD", encoded
    assert_equal value, decoded
  end
end

class URI::UID::IntegerTest < Minitest::Test
  def test_big_decimal
    value = 758423
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert uri.start_with?("uid://universalid/CwKAzgALkpcD")
    assert_equal value, decoded
  end
end
