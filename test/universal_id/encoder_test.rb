# frozen_string_literal: true

require_relative "test_helper"

class UniversalID::EncoderTest < ActiveSupport::TestCase
  def test_new_model
    campaign = Campaign.new(name: "New Campaign")
    encoded = UniversalID::Encoder.encode(campaign)
    decoded = UniversalID::Encoder.decode(encoded)
    assert_equal campaign.as_json, decoded.as_json
  end

  def test_persisted_model
    campaign = Campaign.create(name: "Persisted Campaign")
    encoded = UniversalID::Encoder.encode(campaign)
    decoded = UniversalID::Encoder.decode(encoded)
    assert_equal campaign, decoded
  ensure
    campaign&.destroy
  end
end
