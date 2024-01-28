# frozen_string_literal: true

class UniversalID::Packer::StringTest < Minitest::Test
  def test_big_decimal
    value = "This is a string!"
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal 18, packed.size
    assert_equal "\xB1This is a string!".b, packed
    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::StringTest < Minitest::Test
  def test_big_decimal
    value = "This is a string!"
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal 27, encoded.size
    assert_equal "GxEA-KVBQsJipSKNUFKwLNSnHEI", encoded
    assert_equal value, decoded
  end
end

class URI::UID::StringTest < Minitest::Test
  def test_big_decimal
    value = "This is a string!"
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert uri.start_with?("uid://universalid/GxEA-KVBQsJipSKNUFKwLNSnHEI")
    assert_equal value, decoded
  end
end
