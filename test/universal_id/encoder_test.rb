# frozen_string_literal: true

require_relative "test_helper"

class UniversalID::EncoderTest < ActiveSupport::TestCase
  def test_new_model
    with_new_campaign do |campaign|
      encoded = UniversalID::Encoder.encode(campaign)
      decoded = UniversalID::Encoder.decode(encoded)
      assert_equal campaign.as_json, decoded.as_json
    end
  end

  def test_persisted_model
    with_persisted_campaign do |campaign|
      encoded = UniversalID::Encoder.encode(campaign)
      decoded = UniversalID::Encoder.decode(encoded)
      assert_equal campaign, decoded
    end
  end
end
