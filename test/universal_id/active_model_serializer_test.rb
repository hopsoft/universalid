# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::ActiveModelSerializerTest < ActiveSupport::TestCase
  def setup
    @campaign = Campaign.create!(name: "Example Campaign", description: "Example Description", trigger: "Example Trigger")
    @campaign.emails.create subject: "First Email", body: "Welcome", wait: 1.day
    @campaign.emails.create subject: "Second Email", body: "Follow Up", wait: 1.week
    @campaign.emails.create subject: "Third Email", body: "Hard Sell", wait: 2.days
  end

  def teardown
    @campaign.destroy
  end

  def test_to_packable_hash
    expected = UniversalID::PackableHash.new(campaign: {id: @campaign.id})
    assert_equal expected, @campaign.to_packable_hash(only: %i[id])
  end

  def test_from_packable_hash
    assert_equal @campaign, Campaign.from_packable_hash(@campaign.to_packable_hash)
  end

  def test_to_packable_hash_with_unsaved_changes
    @campaign.name = "Unsaved Change"
    expected = UniversalID::PackableHash.new(campaign: {id: @campaign.id, name: "Unsaved Change"})
    assert_equal expected, @campaign.to_packable_hash(only: %i[id name])
  end

  def test_from_packable_hash_with_unsaved_changes
    @campaign.name = "Unsaved Change"
    assert_equal @campaign, Campaign.from_packable_hash(@campaign.to_packable_hash(only: %i[id name]))
  end
end
