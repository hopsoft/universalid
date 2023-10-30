# frozen_string_literal: true

require_relative "test_helper"

# class UniversalID::ActiveModelSerializerTest < ActiveSupport::TestCase
#   def setup
#     @campaign = Campaign.create!(name: "Example Campaign", description: "Example Description", trigger: "Example Trigger")
#     @campaign.emails.create subject: "First Email", body: "Welcome", wait: 1.day
#     @campaign.emails.create subject: "Second Email", body: "Follow Up", wait: 1.week
#     @campaign.emails.create subject: "Third Email", body: "Hard Sell", wait: 2.days
#   end
#
#   def teardown
#     @campaign.destroy
#   end
#
#   def test_to_packable
#     expected = UniversalID::PackableHash.new(campaign: {id: @campaign.id})
#     actual = @campaign.to_packable(only: %i[id])
#     assert_equal expected.deep_symbolize_keys, actual.deep_symbolize_keys
#   end
#
#   def test_from_packable
#     assert_equal @campaign, Campaign.from_packable(@campaign.to_packable)
#   end
#
#   def test_from_packable_id
#     assert_equal @campaign, Campaign.from_packable(@campaign.to_packable.id)
#   end
#
#   def test_from_packable_gid
#     assert_equal @campaign, Campaign.from_packable(@campaign.to_packable.to_gid)
#   end
#
#   def test_from_packable_gid_param
#     assert_equal @campaign, Campaign.from_packable(@campaign.to_packable.to_gid_param)
#   end
#
#   def test_from_packable_sgid
#     assert_equal @campaign, Campaign.from_packable(@campaign.to_packable.to_sgid)
#   end
#
#   def test_from_packable_sgid_param
#     assert_equal @campaign, Campaign.from_packable(@campaign.to_packable.to_sgid_param)
#   end
#
#   def test_to_packable_with_unsaved_changes
#     @campaign.name = "Unsaved Change"
#     expected = UniversalID::PackableHash.new(campaign: {id: @campaign.id, name: "Unsaved Change"})
#     actual = @campaign.to_packable(only: %i[id name])
#     assert_equal expected.deep_symbolize_keys, actual.deep_symbolize_keys
#   end
#
#   def test_from_packable_with_unsaved_changes
#     @campaign.name = "Unsaved Change"
#     assert_equal @campaign, Campaign.from_packable(@campaign.to_packable(only: %i[id name]))
#   end
#
#   def test_to_packable_with_new_records
#     campaign = Campaign.new(name: "New Campaign", description: "New Description", trigger: "New Trigger")
#     campaign.emails << campaign.emails.build(subject: "New Email 1", body: "I'm not saved!", wait: 1.week)
#     campaign.emails << campaign.emails.build(subject: "New Email 2", body: "I'm not saved!", wait: 1.month)
#
#     expected = {
#       campaign: {
#         id: nil,
#         name: "New Campaign",
#         description: "New Description",
#         trigger: "New Trigger",
#         created_at: nil,
#         updated_at: nil,
#         emails_attributes: [
#           {id: nil, campaign_id: nil, subject: "New Email 1", body: "I'm not saved!", wait: 604800, created_at: nil, updated_at: nil},
#           {id: nil, campaign_id: nil, subject: "New Email 2", body: "I'm not saved!", wait: 2629746, created_at: nil, updated_at: nil}
#         ]
#       }
#     }
#     actual = campaign.to_packable(methods: :emails_attributes)
#     assert_equal expected, actual.deep_symbolize_keys
#
#     id = "eNprXJGcmFuQmJme17IkLzE3dY1farmCM1RodUpqcXJRZkFJZn7eepCEC4K_vKQoMz09tWg1SDwEwt6YmpuYmVMcn1gClEwqLUktntS8vLg0KSs1uQSszhUkr2C4JCk_pXKdp3quQl5-iUJxYllqiuKS8sTMknMMnFYN2LQY4dGioVAEAC9nUH0"
#     actual = campaign.to_packable(methods: :emails_attributes).id
#     assert_equal id, actual
#
#     actual = Campaign.from_packable(actual)
#     assert_equal campaign.attributes, actual.attributes
#     assert_equal campaign.emails.map(&:attributes), actual.emails.map(&:attributes)
#
#     # also works if you don't know the model name(s)
#     actual = ApplicationRecord.from_packable(id) # <- Using ApplicationRecord for the lookup 🤯
#     assert_equal campaign.attributes, actual.attributes
#     assert_equal campaign.emails.map(&:attributes), actual.emails.map(&:attributes)
#   end
# end
