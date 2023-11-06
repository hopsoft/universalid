# frozen_string_literal: true

require_relative "../../test_helper"

class UniversalID::Prepacker::ActiveRecordTest < Minitest::Test
  def test_prepack_new_model_without_config
    skip
    with_new_campaign do |campaign|
      prepacked = UniversalID::Prepacker.prepack(campaign)
      expected = {"9936cecd" => "Campaign"}.merge(campaign.attributes)
      assert_equal expected, prepacked
    end
  end

  def test_prepack_new_model_with_squish_config
    skip
    with_new_campaign do |campaign|
      prepacked = UniversalID::Prepacker.prepack(campaign, UniversalID::Settings.squish.prepack)
      expected = {"9936cecd" => "Campaign"}.merge(campaign.attributes.compact)
      assert_equal expected, prepacked
    end
  end

  def test_persisted_model_without_changes_without_config
    with_persisted_campaign do |campaign|
      prepacked = UniversalID::Prepacker.prepack(campaign)
      expected = {"9936cecd" => "Campaign", "id" => campaign.id}
      assert_equal expected, prepacked
    end
  end

  def test_persisted_model_with_changes_without_config
    with_persisted_campaign do |campaign|
      campaign.description = "Changed Description"
      prepacked = UniversalID::Prepacker.prepack(campaign)
      expected = {"9936cecd" => "Campaign", "id" => campaign.id}
      assert_equal expected, prepacked
    end
  end

  def test_persisted_model_with_changes_with_changes_config
    skip
    with_persisted_campaign do |campaign|
      campaign.description = "Changed Description"
      prepacked = UniversalID::Prepacker.prepack(campaign, UniversalID::Settings.changes)
      expected = {"9936cecd" => "Campaign"}.merge(campaign.attributes)
      assert_equal expected, prepacked
      assert prepacked["description"] == "Changed Description"
    end
  end

  # def test_persisted_model_with_preserve_unsaved_changes
  # with_persisted_campaign do |campaign|
  # campaign.name = "Changed Name"
  # assert campaign.changed?

  # uid = UniversalID.with_config do |config|
  # config.message_pack.active_record.preserve_unsaved_changes = true
  # campaign.to_uid
  # end
  # actual = Campaign.from_uid(uid)
  # assert_equal campaign.attributes, actual.attributes
  # end
  # end

  # def test_persisted_model_with_changes_discard_unsaved_changes
  # with_persisted_campaign do |campaign|
  # campaign.name = "Changed Name"
  # assert campaign.changed?
  # uid = campaign.to_uid
  # actual = Campaign.from_uid(uid)
  # refute_equal campaign.attributes, actual.attributes
  # end
  # end
end
