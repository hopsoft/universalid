# frozen_string_literal: true

class UniversalID::Packer::TrueClassTest < Minitest::Test
  def test_pack_unpack
    value = true
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal 1, packed.size
    assert_equal "\xC3".b, packed
    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::TrueClassTest < Minitest::Test
  def test_encode_decode
    value = true
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal 7, encoded.size
    assert_equal "CwCAwwM", encoded
    assert_equal value, decoded
  end
end

class URI::UID::TrueClassTest < Minitest::Test
  def test_build_parse_decode
    value = true
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert uri.start_with?("uid://universalid/CwCAwwM")
    assert_equal value, decoded
  end

  def test_global_id
    value = true
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_signed_global_id
    value = true
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value, decoded
  end
end
