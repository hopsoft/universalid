# frozen_string_literal: true

class UniversalID::Packer::ActiveRecordAssociationsChangedTest < Minitest::Test
  def apply_changes(campaign)
    campaign.assign_attributes(Campaign.generate_attributes)
    campaign.emails.each do |email|
      email.assign_attributes(Email.generate_attributes)
      email.attachments.each do |attachment|
        attachment.assign_attributes(Attachment.generate_attributes)
      end
    end
  end

  def test_pack_unpack
    expected = Campaign.forge! emails: 3, attachments: 2
    load_has_many expected, depth: 2
    apply_changes expected

    packed = UniversalID::Packer.pack(expected, include_changes: true, include_descendants: true, descendant_depth: 2)
    actual = UniversalID::Packer.unpack(packed)

    assert_has_many_loaded expected, depth: 2
    assert expected.persisted?
    assert expected.changed?
    assert expected.emails do |email|
      assert email.changed?
      email.attachments { |attachment| assert attachment.changed? }
    end
    assert_has_many_loaded actual, depth: 2
    assert_record expected, actual
  end
end

class UniversalID::Encoder::ActiveRecordAssociationsChangedTest < Minitest::Test
  def apply_changes(campaign)
    campaign.assign_attributes(Campaign.generate_attributes)
    campaign.emails.each do |email|
      email.assign_attributes(Email.generate_attributes)
      email.attachments.each do |attachment|
        attachment.assign_attributes(Attachment.generate_attributes)
      end
    end
  end

  def test_encode_decode
    expected = Campaign.forge! emails: 3, attachments: 2
    load_has_many expected, depth: 2
    apply_changes expected

    encoded = UniversalID::Encoder.encode(expected, include_changes: true, include_descendants: true, descendant_depth: 2)
    actual = UniversalID::Encoder.decode(encoded)

    assert_has_many_loaded expected, depth: 2
    assert expected.persisted?
    assert expected.changed?
    assert expected.emails do |email|
      assert email.changed?
      email.attachments { |attachment| assert attachment.changed? }
    end
    assert_has_many_loaded actual, depth: 2
    assert_record expected, actual
  end
end

class URI::UID::ActiveRecordAssociationsChangedTest < Minitest::Test
  def apply_changes(campaign)
    campaign.assign_attributes(Campaign.generate_attributes)
    campaign.emails.each do |email|
      email.assign_attributes(Email.generate_attributes)
      email.attachments.each do |attachment|
        attachment.assign_attributes(Attachment.generate_attributes)
      end
    end
  end

  def test_build_parse_decode
    expected = Campaign.forge! emails: 3, attachments: 2
    load_has_many expected, depth: 2
    apply_changes expected

    uri = URI::UID.build(expected, include_changes: true, include_descendants: true, descendant_depth: 2).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert_has_many_loaded expected, depth: 2
    assert expected.persisted?
    assert expected.changed?
    assert expected.emails do |email|
      assert email.changed?
      email.attachments { |attachment| assert attachment.changed? }
    end
    assert_has_many_loaded actual, depth: 2
    assert_record expected, actual
  end

  def test_global_id
    expected = Campaign.forge! emails: 3, attachments: 2
    load_has_many expected, depth: 2
    apply_changes expected

    gid = URI::UID.build(expected, include_changes: true, include_descendants: true, descendant_depth: 2).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_has_many_loaded expected, depth: 2
    assert expected.persisted?
    assert expected.changed?
    assert expected.emails do |email|
      assert email.changed?
      email.attachments { |attachment| assert attachment.changed? }
    end
    assert_has_many_loaded actual, depth: 2
    assert_record expected, actual
  end

  def test_signed_global_id
    expected = Campaign.forge! emails: 3, attachments: 2
    load_has_many expected, depth: 2
    apply_changes expected

    sgid = URI::UID.build(expected, include_changes: true, include_descendants: true, descendant_depth: 2).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_has_many_loaded expected, depth: 2
    assert expected.persisted?
    assert expected.changed?
    assert expected.emails do |email|
      assert email.changed?
      email.attachments { |attachment| assert attachment.changed? }
    end
    assert_has_many_loaded actual, depth: 2
    assert_record expected, actual
  end
end
