# frozen_string_literal: true

class UniversalID::Packer::FalseClassTest < Minitest::Test
  def test_pack_unpack
    value = false
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal 1, packed.size
    assert_equal "\xC2".b, packed
    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::FalseClassTest < Minitest::Test
  def test_encode_decode
    value = false
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal 7, encoded.size
    assert_equal "CwCAwgM", encoded
    assert_equal value, decoded
  end
end

class URI::UID::FalseClassTest < Minitest::Test
  def test_build_parse_decode
    value = false
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert uri.start_with?("uid://universalid/CwCAwgM")
    assert_equal value, decoded
  end

  def test_global_id
    value = false
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_signed_global_id
    value = false
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value, decoded
  end
end
