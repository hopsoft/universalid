# frozen_string_literal: true

require_relative "../../test_helper"

class URI::UID::ActiveRecordTest < Minitest::Test
  def test_new_model_with_loaded_has_many_associations
    campaign = Campaign.build_for_test
    campaign.emails = Email.build_for_test(3)

    # verify that nothing is persisted
    refute campaign.persisted?
    refute campaign.emails.map(&:persisted?).any?

    options = {
      include_unsaved_changes: true, # required to support new records
      include_descendants: true,
      descendant_depth: 1
    }
    uid = URI::UID.create(campaign, options)
    decoded = URI::UID.parse(uid.to_s).decode

    # verify that the decoded instance is not persisted
    refute decoded.persisted?
    refute decoded.emails.map(&:persisted?).any?

    # verify that the decoded instance is the same as the original
    # and that everything has been restored to the original state
    assert_equal campaign.attributes, decoded.attributes
    assert_equal campaign.emails.map(&:attributes), decoded.emails.map(&:attributes)
  end

  def test_new_model_with_loaded_has_many_associations_exclude_descendants
    campaign = Campaign.build_for_test
    campaign.emails = Email.build_for_test(3)

    options = {
      include_unsaved_changes: true, # required to support new records
      include_descendants: false,
      descendant_depth: 1
    }

    uid = URI::UID.create(campaign, options)
    decoded = URI::UID.parse(uid.to_s).decode
    assert_equal campaign.attributes, decoded.attributes
    assert decoded.emails.none?
  end

  def test_persisted_model_with_loaded_has_many_associations
    campaign = Campaign.create_for_test
    campaign.emails = Email.create_for_test(3)

    # verify that everything is persisted
    assert campaign.persisted?
    assert campaign.emails.map(&:persisted?).all?

    uid = URI::UID.create(campaign, include_descendants: true, descendant_depth: 1)
    decoded = URI::UID.parse(uid.to_s).decode

    # verify that the decoded instance is persisted
    assert decoded.persisted?
    assert decoded.emails.map(&:persisted?).all?

    # verify that the decoded instance is the same as the original
    # and that everything has been restored to the original state
    assert decoded.emails.loaded?
    assert_equal campaign, decoded
    assert_equal campaign.emails, decoded.emails
  end

  def test_persisted_model_with_loaded_has_many_associations_exclude_descendants
    campaign = Campaign.create_for_test
    campaign.emails = Email.create_for_test(3)
    uid = URI::UID.create(campaign, descendant_depth: 1) # include_descendants: false (default)
    decoded = URI::UID.parse(uid.to_s).decode
    assert_equal campaign, decoded
    refute decoded.emails.loaded?
  end

  def test_persisted_model_with_loaded_has_many_associations_include_descendants_descendant_depth_0
    campaign = Campaign.create_for_test
    campaign.emails = Email.create_for_test 3
    uid = URI::UID.create(campaign, include_descendants: true) # descendant_depth: 0 (default)
    decoded = URI::UID.parse(uid.to_s).decode
    assert_equal campaign, decoded
    refute decoded.emails.loaded?
  end

  def test_persisted_model_with_loaded_has_many_associations_2_deep
    campaign = Campaign.create_for_test
    campaign.emails = Email.create_for_test(3) do |email|
      email.attachments = Attachment.create_for_test(2)
    end

    uid = URI::UID.create(campaign, include_descendants: true, descendant_depth: 2)
    decoded = URI::UID.parse(uid.to_s).decode

    assert_equal campaign, decoded
    assert_equal campaign.emails, decoded.emails
    assert_equal campaign.emails.map(&:attachments), decoded.emails.map(&:attachments)
    assert decoded.emails.loaded?
    assert decoded.emails.map(&:attachments).map(&:loaded)
  end

  def test_persisted_model_with_loaded_has_many_associations_2_deep_with_changes
    campaign = Campaign.create_for_test
    campaign.name = "Changed Campaign"
    campaign.emails = Email.create_for_test(3) do |email|
      email.subject = "Changed Subject #{email.id}"
      email.attachments = Attachment.create_for_test(2) do |attachment|
        attachment.file_name = "changed.txt"
      end
    end

    options = {
      include_unsaved_changes: true,
      include_descendants: true,
      descendant_depth: 2
    }

    uid = URI::UID.create(campaign, options)
    decoded = URI::UID.parse(uid.to_s).decode

    # verify in-memory records have changes
    assert campaign.changed?
    assert campaign.emails.map(&:changed?)
    assert campaign.emails.map(&:attachments).flatten.map(&:changed?)

    # verify decoded records also have changes
    assert decoded.changed?
    assert decoded.emails.map(&:changed?)
    assert decoded.emails.map(&:attachments).flatten.map(&:changed?)

    # verify that the in-memory and decoded records are the same
    assert_equal campaign, decoded
    assert_equal campaign.emails, decoded.emails
    assert_equal campaign.emails.map(&:attachments), decoded.emails.map(&:attachments)
    assert decoded.emails.map(&:attachments).map(&:loaded)
  end
end
