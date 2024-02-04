# frozen_string_literal: true

class UniversalID::Packer::DateTest < Minitest::Test
  def test_pack_unpack
    expected = Date.parse("2024-01-28")
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal 14, packed.size
    assert_equal "\xC7\v\x05\xAA2024-01-28".b, packed
    assert_equal expected, actual
  end
end

class UniversalID::Encoder::DateTest < Minitest::Test
  def test_encode_decode
    expected = Date.parse("2024-01-28")
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal 24, encoded.size
    assert_equal "iwaAxwsFqjIwMjQtMDEtMjgD", encoded
    assert_equal expected, actual
  end
end

class URI::UID::DateTest < Minitest::Test
  def test_build_parse_decode
    expected = Date.parse("2024-01-28")
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert uri.start_with?("uid://universalid/iwaAxwsFqjIwMjQtMDEtMjgD")
    assert_equal expected, actual
  end

  def test_global_id
    expected = Date.parse("2024-01-28")
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_signed_global_id
    expected = Date.parse("2024-01-28")
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_equal expected, actual
  end
end
