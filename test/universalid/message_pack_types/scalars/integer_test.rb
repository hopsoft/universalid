# frozen_string_literal: true

class UniversalID::Packer::IntegerTest < Minitest::Test
  def test_pack_unpack
    expected = 758423
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal 5, packed.size
    assert_equal "\xCE\x00\v\x92\x97".b, packed
    assert_equal expected, actual
  end
end

class UniversalID::Encoder::IntegerTest < Minitest::Test
  def test_encode_decode
    expected = 758423
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal 12, encoded.size
    assert_equal "CwKAzgALkpcD", encoded
    assert_equal expected, actual
  end
end

class URI::UID::IntegerTest < Minitest::Test
  def test_build_parse_decode
    expected = 758423
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert uri.start_with?("uid://universalid/CwKAzgALkpcD")
    assert_equal expected, actual
  end

  def test_global_id
    expected = 758423
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_signed_global_id
    expected = 758423
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_equal expected, actual
  end
end
