# frozen_string_literal: true

class UniversalID::Packer::DateTimeTest < Minitest::Test
  def test_pack_unpack
    expected = DateTime.new(2023, 2, 3, 4, 5, 6)
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal 40, packed.size
    assert_equal "\xC7%\x04\xD9#2023-02-03T04:05:06.000000000+00:00".b, packed
    assert_equal expected, actual
  end
end

class UniversalID::Encoder::DateTimeTest < Minitest::Test
  def test_encode_decode
    expected = DateTime.new(2023, 2, 3, 4, 5, 6)
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal 56, encoded.size
    assert_equal "GycA-I2UqT1eHWcT5K1IzSR7uz2EL1lpAlIAMIy2p9whw_5OueUtAFMB", encoded
    assert_equal expected, actual
  end
end

class URI::UID::DateTimeTest < Minitest::Test
  def test_build_parse_decode
    expected = DateTime.new(2023, 2, 3, 4, 5, 6)
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert uri.start_with?("uid://universalid/GycA-I2UqT1eHWcT5K1IzSR7uz2EL1lpAlIAMIy2p9whw_5OueUtAFMB")
    assert_equal expected, actual
  end

  def test_global_id
    expected = DateTime.new(2023, 2, 3, 4, 5, 6)
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_signed_global_id
    expected = DateTime.new(2023, 2, 3, 4, 5, 6)
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_equal expected, actual
  end
end
