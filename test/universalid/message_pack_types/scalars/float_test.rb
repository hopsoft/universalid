# frozen_string_literal: true

class UniversalID::Packer::FloatTest < Minitest::Test
  def test_pack_unpack
    value = 789.456
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal 9, packed.size
    assert_equal "\xCB@\x88\xAB\xA5\xE3S\xF7\xCF".b, packed
    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::FloatTest < Minitest::Test
  def test_encode_decode
    value = 789.456
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal 18, encoded.size
    assert_equal "CwSAy0CIq6XjU_fPAw", encoded
    assert_equal value, decoded
  end
end

class URI::UID::FloatTest < Minitest::Test
  def test_build_parse_decode
    value = 789.456
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert uri.start_with?("uid://universalid/CwSAy0CIq6XjU_fPAw")
    assert_equal value, decoded
  end

  def test_global_id
    value = 789.456
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_signed_global_id
    value = 789.456
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value, decoded
  end
end
