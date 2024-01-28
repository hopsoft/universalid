# frozen_string_literal: true

class UniversalID::Packer::DateTimeTest < Minitest::Test
  def test_big_decimal
    value = DateTime.new(2023, 2, 3, 4, 5, 6)
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal 40, packed.size
    assert_equal "\xC7%\x04\xD9#2023-02-03T04:05:06.000000000+00:00".b, packed
    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::DateTimeTest < Minitest::Test
  def test_big_decimal
    value = DateTime.new(2023, 2, 3, 4, 5, 6)
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal 56, encoded.size
    assert_equal "GycA-I2UqT1eHWcT5K1IzSR7uz2EL1lpAlIAMIy2p9whw_5OueUtAFMB", encoded
    assert_equal value, decoded
  end
end

class URI::UID::DateTimeTest < Minitest::Test
  def test_big_decimal
    value = DateTime.new(2023, 2, 3, 4, 5, 6)
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert uri.start_with?("uid://universalid/GycA-I2UqT1eHWcT5K1IzSR7uz2EL1lpAlIAMIy2p9whw_5OueUtAFMB")
    assert_equal value, decoded
  end
end
