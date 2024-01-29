# frozen_string_literal: true

class UniversalID::Packer::RangeTest < Minitest::Test
  def test_pack_unpack
    value = (7..42)
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal 8, packed.size
    assert_equal "\xC7\x05\x06\a\xA2..*".b, packed
    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::RangeTest < Minitest::Test
  def test_encode_decode
    value = (7..42)
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal 16, encoded.size
    assert_equal "iwOAxwUGB6IuLioD", encoded
    assert_equal value, decoded
  end
end

class URI::UID::RangeTest < Minitest::Test
  def test_build_parse_decode
    value = (7..42)
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert uri.start_with?("uid://universalid/iwOAxwUGB6IuLioD")
    assert_equal value, decoded
  end

  def test_global_id
    value = (7..42)
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_signed_global_id
    value = (7..42)
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value, decoded
  end
end
