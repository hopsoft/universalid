# frozen_string_literal: true

module UniversalID::MessagePackTypes
  class GlobalIDTest < Minitest::Test
    def test_global_id
      campaign = Campaign.create_for_test
      expected = campaign.to_gid
      packed = UniversalID::MessagePackFactory.pack(campaign.to_gid)
      unpacked = UniversalID::MessagePackFactory.unpack(packed)
      assert_equal expected, unpacked
    end

    def test_signed_global_id
      campaign = Campaign.create_for_test
      expected = campaign.to_sgid
      packed = UniversalID::MessagePackFactory.pack(campaign.to_sgid)
      unpacked = UniversalID::MessagePackFactory.unpack(packed)
      assert_equal expected, unpacked
    end

    def test_implicit_global_id
      campaign = Campaign.create_for_test
      packed = UniversalID::MessagePackFactory.pack(campaign)
      unpacked = UniversalID::MessagePackFactory.unpack(packed)
      assert_equal campaign, unpacked
    end
  end
end
