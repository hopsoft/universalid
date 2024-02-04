# frozen_string_literal: true

class UniversalID::Packer::FloatTest < Minitest::Test
  def test_pack_unpack
    expected = 789.456
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal 9, packed.size
    assert_equal "\xCB@\x88\xAB\xA5\xE3S\xF7\xCF".b, packed
    assert_equal expected, actual
  end
end

class UniversalID::Encoder::FloatTest < Minitest::Test
  def test_encode_decode
    expected = 789.456
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal 18, encoded.size
    assert_equal "CwSAy0CIq6XjU_fPAw", encoded
    assert_equal expected, actual
  end
end

class URI::UID::FloatTest < Minitest::Test
  def test_build_parse_decode
    expected = 789.456
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert uri.start_with?("uid://universalid/CwSAy0CIq6XjU_fPAw")
    assert_equal expected, actual
  end

  def test_global_id
    expected = 789.456
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_signed_global_id
    expected = 789.456
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_equal expected, actual
  end
end
