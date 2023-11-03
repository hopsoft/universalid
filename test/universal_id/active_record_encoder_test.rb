# frozen_string_literal: true

require_relative "test_helper"

class UniversalID::ActiveRecordEncoderTest < Minitest::Test
  def test_new_model
    with_new_campaign do |campaign|
      uid = campaign.to_uid
      actual = Campaign.from_uid(uid)
      assert_equal campaign.attributes, actual.attributes
    end
  end

  def test_persisted_model_without_changes
    with_persisted_campaign do |campaign|
      uid = campaign.to_uid
      actual = Campaign.from_uid(uid)
      assert_equal campaign.attributes, actual.attributes
    end
  end

  def test_persisted_model_with_changes_keep_changes
    with_persisted_campaign do |campaign|
      campaign.name = "Changed Name"
      assert campaign.changed?

      uid = begin
        # TODO: Improve on the verbose options override semantics
        UniversalID.config.message_packer[:global_id][:identification][:active_record][:keep_changes] = true
        campaign.to_uid
      ensure
        # TODO: Improve on the verbose options override semantics
        UniversalID.config.message_packer[:global_id][:identification][:active_record][:keep_changes] = false
      end
      actual = Campaign.from_uid(uid)
      assert_equal campaign.attributes, actual.attributes
    end
  end

  def test_persisted_model_with_changes_discard_changes
    with_persisted_campaign do |campaign|
      campaign.name = "Changed Name"
      assert campaign.changed?
      uid = campaign.to_uid
      actual = Campaign.from_uid(uid)
      refute_equal campaign.attributes, actual.attributes
    end
  end
end
