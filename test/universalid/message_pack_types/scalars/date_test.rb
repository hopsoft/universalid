# frozen_string_literal: true

class UniversalID::Packer::DateTest < Minitest::Test
  def test_pack_unpack
    value = Date.parse("2024-01-28")
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal 14, packed.size
    assert_equal "\xC7\v\x05\xAA2024-01-28".b, packed
    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::DateTest < Minitest::Test
  def test_encode_decode
    value = Date.parse("2024-01-28")
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal 24, encoded.size
    assert_equal "iwaAxwsFqjIwMjQtMDEtMjgD", encoded
    assert_equal value, decoded
  end
end

class URI::UID::DateTest < Minitest::Test
  def test_build_parse_decode
    value = Date.parse("2024-01-28")
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert uri.start_with?("uid://universalid/iwaAxwsFqjIwMjQtMDEtMjgD")
    assert_equal value, decoded
  end

  def test_global_id
    value = Date.parse("2024-01-28")
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_signed_global_id
    value = Date.parse("2024-01-28")
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value, decoded
  end
end
