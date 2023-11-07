# frozen_string_literal: true

require_relative "../../test_helper"

class UniversalID::Encoder::ActiveRecordTest < Minitest::Test
  def test_new_model
    with_new_campaign do |campaign|
      encoded = UniversalID::Encoder.encode(campaign)
      expected = "G0oAwIzURjlXsihz6g51czUItiriDDbDYzqHy1_KwCFHdlD7FnBGKdWexYf1PYhGBuYP1F3gMZefkHdSPiDmK2oA"
      assert_equal expected, encoded

      decoded = UniversalID::Encoder.decode(encoded)
      expected = {"9936cecd" => "Campaign", "id" => nil, "name" => nil, "description" => nil, "trigger" => nil, "created_at" => nil, "updated_at" => nil}
      assert_equal expected, decoded
    end
  end

  def test_new_model_include_unsaved_changes
    with_new_campaign do |campaign|
      encoded = UniversalID::Encoder.encode(campaign, include_unsaved_changes: true)
      decoded = UniversalID::Encoder.decode(encoded)
      expected = {"9936cecd" => "Campaign", "id" => nil, "name" => campaign.name, "description" => nil, "trigger" => nil, "created_at" => nil, "updated_at" => nil}
      assert_equal expected, decoded
    end
  end

  def test_new_model_include_unsaved_changes_exclude_blanks
    with_new_campaign do |campaign|
      encoded = UniversalID::Encoder.encode(campaign, include_unsaved_changes: true, include_blank: false)
      decoded = UniversalID::Encoder.decode(encoded)
      expected = {"9936cecd" => "Campaign", "name" => campaign.name}
      assert_equal expected, decoded
    end
  end

  def test_persisted_model
    with_persisted_campaign do |campaign|
      encoded = UniversalID::Encoder.encode(campaign)
      decoded = UniversalID::Encoder.decode(encoded)
      expected = {"9936cecd" => "Campaign", "id" => campaign.id}
      assert_equal expected, decoded
    end
  end

  def test_changed_persisted_model
    with_persisted_campaign do |campaign|
      campaign.description = "Changed Description"
      encoded = UniversalID::Encoder.encode(campaign)
      decoded = UniversalID::Encoder.decode(encoded)
      expected = {"9936cecd" => "Campaign", "id" => campaign.id}
      assert_equal expected, decoded
    end
  end

  def test_changed_persisted_model_include_unsaved_changes
    with_persisted_campaign do |campaign|
      campaign.description = "Changed Description"
      encoded = UniversalID::Encoder.encode(campaign, include_unsaved_changes: true)
      decoded = UniversalID::Encoder.decode(encoded)
      expected = {
        "9936cecd" => "Campaign",
        "id" => campaign.id,
        "name" => campaign.name,
        "description" => "Changed Description",
        "trigger" => campaign.trigger,
        "created_at" => campaign.created_at,
        "updated_at" => campaign.updated_at
      }
      assert_equal expected, decoded
    end
  end

  def test_changed_persisted_model_with_registered_custom_config
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

    _, settings = UniversalID::Settings.register("test_#{SecureRandom.alphanumeric(8)}", YAML.safe_load(yaml))

    with_persisted_campaign do |campaign|
      campaign.name = "Changed Name"
      campaign.description = "Changed Description"
      campaign.trigger = "Changed Trigger"

      encoded = UniversalID::Encoder.encode(campaign, **settings)
      decoded = UniversalID::Encoder.decode(encoded)
      expected = {"9936cecd" => "Campaign", "id" => campaign.id, "name" => "Changed Name"}
      assert_equal expected, decoded
    end
  end
end
