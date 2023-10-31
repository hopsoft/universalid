# frozen_string_literal: true

require_relative "../../test_helper"

class UniversalID::URI::UIDTest < ActiveSupport::TestCase
  def test_create_with_model
    with_persisted_campaign do |campaign|
      uid = UniversalID::URI::UID.create(campaign)
      assert_valid_uid uid
      assert_equal campaign, uid.decode
    end
  end

  def test_create_with_model_in_array
    with_persisted_campaign do |campaign|
      expected = [123, "data", [1, 2, 3], {model: campaign}]
      uid = UniversalID::URI::UID.create(expected)
      assert_equal expected, uid.decode
    end
  end

  def test_create_with_model_in_hash
    with_persisted_campaign do |campaign|
      expected = {number: 123, string: "data", array: [1, 2, 3], hash: {model: campaign}}
      uid = UniversalID::URI::UID.create(expected)
      assert_equal expected, uid.decode
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
