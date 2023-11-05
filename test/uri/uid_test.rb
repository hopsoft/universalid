# frozen_string_literal: true

require_relative "../test_helper"

class URI::UIDTest < Minitest::Test
  # def test_create_with_model
  # with_persisted_campaign do |campaign|
  # uid = URI::UID.create(campaign)
  # assert uid.valid?
  # assert_equal campaign, uid.decode
  # end
  # end

  # def test_create_with_model_in_array
  # with_persisted_campaign do |campaign|
  # expected = [123, "data", [1, 2, 3], {model: campaign}]
  # uid = URI::UID.create(expected)
  # assert_equal expected, uid.decode
  # end
  # end

  # def test_create_with_model_in_hash
  # with_persisted_campaign do |campaign|
  # expected = {number: 123, string: "data", array: [1, 2, 3], hash: {model: campaign}}
  # uid = URI::UID.create(expected)
  # assert_equal expected, uid.decode
  # end
  # end
end
