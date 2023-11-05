# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::EncoderTest < Minitest::Test
  # def test_new_model
  # with_new_campaign do |campaign|
  # encoded = UniversalID::Encoder.encode(campaign)
  # decoded = UniversalID::Encoder.decode(encoded)
  # assert_equal campaign.attributes, decoded.attributes
  # end
  # end

  # def test_persisted_model_without_changes
  # with_persisted_campaign do |campaign|
  # encoded = UniversalID::Encoder.encode(campaign)
  # decoded = UniversalID::Encoder.decode(encoded)
  # assert_equal campaign.attributes, decoded.attributes
  # end
  # end

  # def test_persisted_model_with_changes_preserve_unsaved_changes
  # with_persisted_campaign do |campaign|
  # campaign.name = "Changed Name"
  # assert campaign.changed?

  # encoded = UniversalID.with_config do |config|
  # config.message_pack.active_record.preserve_unsaved_changes = true
  # UniversalID::Encoder.encode campaign
  # end
  # decoded = UniversalID::Encoder.decode(encoded)
  # assert_equal campaign.attributes, decoded.attributes
  # end
  # end

  # def test_persisted_model_with_changes_discard_unsaved_changes
  # with_persisted_campaign do |campaign|
  # campaign.name = "Changed Name"
  # assert campaign.changed?
  # encoded = UniversalID::Encoder.encode(campaign)
  # decoded = UniversalID::Encoder.decode(encoded)
  # refute_equal campaign.attributes, decoded.attributes
  # end
  # end
end
