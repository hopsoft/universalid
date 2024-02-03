# frozen_string_literal: true

class UniversalID::Packer::ActiveRecordPersistedTest < Minitest::Test
  def test_pack_unpack
    value = Campaign.forge!
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::ActiveRecordPersistedTest < Minitest::Test
  def test_encode_decode
    value = Campaign.forge!
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal value, decoded
  end
end

class URI::UID::ActiveRecordPersistedTest < Minitest::Test
  def test_build_parse_decode
    value = Campaign.forge!
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_global_id
    value = Campaign.forge!
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_signed_global_id
    value = Campaign.forge!
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value, decoded
  end
end
