# frozen_string_literal: true

class UniversalID::Packer::TrueClassTest < Minitest::Test
  def test_pack_unpack
    expected = true
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal 1, packed.size
    assert_equal "\xC3".b, packed
    assert_equal expected, actual
  end
end

class UniversalID::Encoder::TrueClassTest < Minitest::Test
  def test_encode_decode
    expected = true
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal 7, encoded.size
    assert_equal "CwCAwwM", encoded
    assert_equal expected, actual
  end
end

class URI::UID::TrueClassTest < Minitest::Test
  def test_build_parse_decode
    expected = true
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert uri.start_with?("uid://universalid/CwCAwwM")
    assert_equal expected, actual
  end

  def test_global_id
    expected = true
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_signed_global_id
    expected = true
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_equal expected, actual
  end
end
