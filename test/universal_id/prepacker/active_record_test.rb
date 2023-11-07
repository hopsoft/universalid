# frozen_string_literal: true

require_relative "../../test_helper"

class UniversalID::Prepacker::ActiveRecordTest < Minitest::Test
  def test_prepack_new_model_without_override
    with_new_campaign do |campaign|
      prepacked = UniversalID::Prepacker.prepack(campaign, include_unsaved_changes: true)
      expected = {"9936cecd" => "Campaign"}.merge(campaign.attributes)
      assert_equal expected, prepacked
    end
  end

  def test_prepack_new_model_with_squish_override
    with_new_campaign do |campaign|
      prepacked = UniversalID::Prepacker.prepack(campaign, include_unsaved_changes: true, include_blank: false)
      expected = {"9936cecd" => "Campaign", "name" => campaign.name}
      assert_equal expected, prepacked
    end
  end

  def test_persisted_model_without_changes_without_override
    with_persisted_campaign do |campaign|
      prepacked = UniversalID::Prepacker.prepack(campaign)
      expected = {"9936cecd" => "Campaign", "id" => campaign.id}
      assert_equal expected, prepacked
    end
  end

  def test_persisted_model_with_changes_without_override
    with_persisted_campaign do |campaign|
      campaign.description = "Changed Description"
      prepacked = UniversalID::Prepacker.prepack(campaign)
      expected = {"9936cecd" => "Campaign", "id" => campaign.id}
      assert_equal expected, prepacked
    end
  end

  def test_persisted_model_with_changes_with_changes_override
    with_persisted_campaign do |campaign|
      campaign.description = "Changed Description"
      prepacked = UniversalID::Prepacker.prepack(campaign, include_unsaved_changes: true)
      expected = {
        "9936cecd" => "Campaign",
        "id" => campaign.id,
        "name" => campaign.name,
        "description" => "Changed Description",
        "trigger" => campaign.trigger,
        "created_at" => campaign.created_at,
        "updated_at" => campaign.updated_at
      }
      assert_equal expected, prepacked
    end
  end

  def test_persisted_model_with_changes_with_registered_config
    yaml = <<~YAML
      prepack:
        exclude:
          - description
          - trigger
        include_blank: false

        database:
          include_unsaved_changes: true
          include_timestamps: false
    YAML

    UniversalID::Settings.register :my_test_settings, YAML.safe_load(yaml)

    with_persisted_campaign do |campaign|
      campaign.name = "Changed Name"
      campaign.description = "Changed Description"
      campaign.trigger = "Changed Trigger"

      prepacked = UniversalID::Prepacker.prepack(campaign, UniversalID::Settings.my_test_settings.prepack)
      expected = {"9936cecd" => "Campaign", "id" => campaign.id, "name" => "Changed Name"}

      assert_equal expected, prepacked
    end
  end

  # def test_persisted_model_with_preserve_unsaved_changes
  # with_persisted_campaign do |campaign|
  # campaign.name = "Changed Name"
  # assert campaign.changed?

  # uid = UniversalID.with_override do |config|
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
