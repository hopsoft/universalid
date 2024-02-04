# frozen_string_literal: true

class UniversalID::Packer::ActiveRecordAssociationsUnpersistedTest < Minitest::Test
  def test_pack_unpack
    expected = Campaign.forge emails: 3, attachments: 2

    packed = UniversalID::Packer.pack(expected, include_changes: true, include_descendants: true, descendant_depth: 2)
    actual = UniversalID::Packer.unpack(packed)

    assert_has_many_loaded expected, depth: 2
    assert expected.new_record?
    assert_has_many_loaded actual, depth: 2
    assert_record expected, actual
  end
end

class UniversalID::Encoder::ActiveRecordAssociationsUnpersistedTest < Minitest::Test
  def test_encode_decode
    expected = Campaign.forge emails: 3, attachments: 2

    encoded = UniversalID::Encoder.encode(expected, include_changes: true, include_descendants: true, descendant_depth: 2)
    actual = UniversalID::Encoder.decode(encoded)

    assert_has_many_loaded expected, depth: 2
    assert expected.new_record?
    assert_has_many_loaded actual, depth: 2
    assert_record expected, actual
  end
end

class URI::UID::ActiveRecordAssociationsUnpersistedTest < Minitest::Test
  def test_build_parse_decode
    expected = Campaign.forge emails: 3, attachments: 2

    uri = URI::UID.build(expected, include_changes: true, include_descendants: true, descendant_depth: 2).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert_has_many_loaded expected, depth: 2
    assert expected.new_record?
    assert_has_many_loaded actual, depth: 2
    assert_record expected, actual
  end

  def test_global_id
    expected = Campaign.forge emails: 3, attachments: 2

    gid = URI::UID.build(expected, include_changes: true, include_descendants: true, descendant_depth: 2).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_has_many_loaded expected, depth: 2
    assert expected.new_record?
    assert_has_many_loaded actual, depth: 2
    assert_record expected, actual
  end

  def test_signed_global_id
    expected = Campaign.forge emails: 3, attachments: 2

    sgid = URI::UID.build(expected, include_changes: true, include_descendants: true, descendant_depth: 2).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_has_many_loaded expected, depth: 2
    assert expected.new_record?
    assert_has_many_loaded actual, depth: 2
    assert_record expected, actual
  end
end
