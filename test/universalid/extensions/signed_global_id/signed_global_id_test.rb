# frozen_string_literal: true

class UniversalID::Packer::SignedGlobalIDTest < Minitest::Test
  def test_pack_unpack
    expected = Campaign.forge!.to_sgid
    packed = UniversalID::Packer.pack(expected)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal expected, unpacked
  end
end

class UniversalID::Encoder::SignedGlobalIDTest < Minitest::Test
  def test_encode_decode
    expected = Campaign.forge!.to_sgid
    encoded = UniversalID::Encoder.encode(expected)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal expected, decoded
  end
end

class URI::UID::SignedGlobalIDTest < Minitest::Test
  def test_build_parse_decode
    expected = Campaign.forge!.to_sgid
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert_equal expected, decoded
  end

  def test_global_id
    expected = Campaign.forge!.to_sgid
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal expected, decoded
  end

  def test_signed_global_id
    expected = Campaign.forge!.to_sgid
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal expected, decoded
  end
end
