# frozen_string_literal: true

class UniversalID::Packer::ActiveRecordUnpersistedTest < Minitest::Test
  def test_pack_unpack
    expected = Campaign.forge
    packed = UniversalID::Packer.pack(expected, include_changes: true)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal expected.attributes, actual.attributes
  end
end

class UniversalID::Encoder::ActiveRecordUnpersistedTest < Minitest::Test
  def test_encode_decode
    expected = Campaign.forge
    encoded = UniversalID::Encoder.encode(expected, include_changes: true)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal expected.attributes, actual.attributes
  end
end

class URI::UID::ActiveRecordUnpersistedTest < Minitest::Test
  def test_build_parse_decode
    expected = Campaign.forge
    uri = URI::UID.build(expected, include_changes: true).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert_equal expected.attributes, actual.attributes
  end

  def test_global_id
    expected = Campaign.forge
    gid = URI::UID.build(expected, include_changes: true).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_equal expected.attributes, actual.attributes
  end

  def test_signed_global_id
    expected = Campaign.forge
    sgid = URI::UID.build(expected, include_changes: true).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_equal expected.attributes, actual.attributes
  end
end
