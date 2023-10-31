# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::UIDTest < ActiveSupport::TestCase
  def test_create_with_model
    with_persisted_campaign do |campaign|
      uid = UniversalID::URI::UID.create(campaign)
      assert_valid_uid uid
      assert_equal campaign, uid.decode
    end
  end

  def test_create_with_model_in_array
    with_persisted_campaign do |campaign|
      expected = [123, campaign, "test"]
      uid = UniversalID::URI::UID.create(expected)
      assert_equal expected, uid.decode
      assert_equal campaign, expected[1]
    end
  end

  def test_create_with_model_in_hash
    with_persisted_campaign do |campaign|
      expected = {num: 123, campaign: campaign, str: "test"}
      uid = UniversalID::URI::UID.create(expected)
      assert_equal expected, uid.decode
      assert_equal campaign, expected[:campaign]
    end
  end

  private

  def assert_valid_uid(uid)
    assert uid.valid?
    assert uid.decodable?
    assert_equal "UniversalID::TestSuite", uid.app_name
    assert_equal ::UniversalID::TestSuite, uid.app
  end
end
