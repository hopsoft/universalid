# frozen_string_literal: true

class UniversalID::Packer::NilClassTest < Minitest::Test
  def test_pack_unpack
    value = nil
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal 1, packed.size
    assert_equal "\xC0".b, packed
    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::NilClassTest < Minitest::Test
  def test_encode_decode
    value = nil
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal 7, encoded.size
    assert_equal "CwCAwAM", encoded
    assert_equal value, decoded
  end
end

class URI::UID::NilClassTest < Minitest::Test
  def test_build_parse_decode
    value = nil
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert uri.start_with?("uid://universalid/CwCAwAM")
    assert_equal value, decoded
  end

  def test_global_id
    value = nil
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_signed_global_id
    value = nil
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value, decoded
  end
end
