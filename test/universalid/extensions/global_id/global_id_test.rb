# frozen_string_literal: true

class UniversalID::Packer::GlobalIDTest < Minitest::Test
  def test_pack_unpack
    record = Campaign.forge!
    value = record.to_gid
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::GlobalIDTest < Minitest::Test
  def test_encode_decode
    record = Campaign.forge!
    value = record.to_gid
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal value, decoded
  end
end

class URI::UID::GlobalIDTest < Minitest::Test
  def test_build_parse_decode
    record = Campaign.forge!
    value = record.to_gid
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_global_id
    record = Campaign.forge!
    value = record.to_gid
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_signed_global_id
    record = Campaign.forge!
    value = record.to_gid
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value, decoded
  end
end
