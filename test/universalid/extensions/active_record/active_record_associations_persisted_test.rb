# frozen_string_literal: true

class UniversalID::Packer::ActiveRecordAssociationsPersistedTest < Minitest::Test
  def test_pack_unpack
    expected = Campaign.forge! emails: 3, attachments: 2
    load_has_many expected, depth: 2

    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_has_many_loaded expected, depth: 2
    assert expected.persisted?
    refute_has_many_loaded actual
    assert_record expected, actual
  end
end

class UniversalID::Encoder::ActiveRecordAssociationsPersistedTest < Minitest::Test
  def test_encode_decode
    expected = Campaign.forge! emails: 3, attachments: 2
    load_has_many expected, depth: 2

    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_has_many_loaded expected, depth: 2
    assert expected.persisted?
    refute_has_many_loaded actual
    assert_record expected, actual
  end
end

class URI::UID::ActiveRecordAssociationsPersistedTest < Minitest::Test
  def test_build_parse_decode
    expected = Campaign.forge! emails: 3, attachments: 2
    load_has_many expected, depth: 2

    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert_has_many_loaded expected, depth: 2
    assert expected.persisted?
    refute_has_many_loaded actual
    assert_record expected, actual
  end

  def test_global_id
    expected = Campaign.forge! emails: 3, attachments: 2
    load_has_many expected, depth: 2

    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_has_many_loaded expected, depth: 2
    assert expected.persisted?
    refute_has_many_loaded actual
    assert_record expected, actual
  end

  def test_signed_global_id
    expected = Campaign.forge! emails: 3, attachments: 2
    load_has_many expected, depth: 2

    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_has_many_loaded expected, depth: 2
    assert expected.persisted?
    refute_has_many_loaded actual
    assert_record expected, actual
  end
end
