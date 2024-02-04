# frozen_string_literal: true

class UniversalID::Packer::GlobalIDTest < Minitest::Test
  def test_pack_unpack
    expected = Campaign.forge!.to_gid
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal expected, actual
  end
end

class UniversalID::Encoder::GlobalIDTest < Minitest::Test
  def test_encode_decode
    expected = Campaign.forge!.to_gid
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal expected, actual
  end
end

class URI::UID::GlobalIDTest < Minitest::Test
  def test_build_parse_decode
    expected = Campaign.forge!.to_gid
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_global_id
    expected = Campaign.forge!.to_gid
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_signed_global_id
    expected = Campaign.forge!.to_gid
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_equal expected, actual
  end
end
