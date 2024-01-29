# frozen_string_literal: true

class UniversalID::Packer::RationalTest < Minitest::Test
  def test_pack_unpack
    value = Rational(24, 3)
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal 6, packed.size
    assert_equal "\xD6\x03\xA38/1".b, packed
    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::RationalTest < Minitest::Test
  def test_encode_decode
    value = Rational(24, 3)
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal 14, encoded.size
    assert_equal "iwKA1gOjOC8xAw", encoded
    assert_equal value, decoded
  end
end

class URI::UID::RationalTest < Minitest::Test
  def test_build_parse_decode
    value = Rational(24, 3)
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert uri.start_with?("uid://universalid/iwKA1gOjOC8xAw")
    assert_equal value, decoded
  end

  def test_global_id
    value = Rational(24, 3)
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_signed_global_id
    value = Rational(24, 3)
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value, decoded
  end
end
