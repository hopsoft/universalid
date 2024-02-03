# frozen_string_literal: true

class UniversalID::Packer::ActiveRecordChangedTest < Minitest::Test
  def test_pack_unpack
    value = Campaign.forge!
    value.assign_attributes(Campaign.generate_attributes)

    assert value.changed?

    packed = UniversalID::Packer.pack(value, include_changes: true)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal value.attributes, unpacked.attributes
  end
end

class UniversalID::Encoder::ActiveRecordChangedTest < Minitest::Test
  def test_encode_decode
    value = Campaign.forge!
    value.assign_attributes(Campaign.generate_attributes)

    assert value.changed?

    encoded = UniversalID::Encoder.encode(value, include_changes: true)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal value.attributes, decoded.attributes
  end
end

class URI::UID::ActiveRecordChangedTest < Minitest::Test
  def test_build_parse_decode
    value = Campaign.forge!
    value.assign_attributes(Campaign.generate_attributes)

    assert value.changed?

    uri = URI::UID.build(value, include_changes: true).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert_equal value.attributes, decoded.attributes
  end

  def test_global_id
    value = Campaign.forge!
    value.assign_attributes(Campaign.generate_attributes)

    assert value.changed?

    gid = URI::UID.build(value, include_changes: true).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value.attributes, decoded.attributes
  end

  def test_signed_global_id
    value = Campaign.forge!
    value.assign_attributes(Campaign.generate_attributes)

    assert value.changed?

    sgid = URI::UID.build(value, include_changes: true).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value.attributes, decoded.attributes
  end
end
