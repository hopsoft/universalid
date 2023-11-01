# frozen_string_literal: true

require_relative "test_helper"

class UniversalID::ActiveRecordEncoderTest < ActiveSupport::TestCase
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
      uid = campaign.to_uid(active_record: {keep_changes: true})
      actual = Campaign.from_uid(uid)
      assert_equal campaign.attributes, actual.attributes
    end
  end

  def test_persisted_model_with_changes_discard_changes
    with_persisted_campaign do |campaign|
      campaign.name = "Changed Name"
      assert campaign.changed?
      uid = campaign.to_uid(active_record: {keep_changes: false})
      actual = Campaign.from_uid(uid)
      refute_equal campaign.attributes, actual.attributes
    end
  end
end
