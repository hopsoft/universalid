# frozen_string_literal: true

require_relative "../../test_helper"

module UniversalID::MessagePackTypes
  class GlobalIDTest < Minitest::Test
    def test_global_id
      with_persisted_campaign do |campaign|
        expected = campaign.to_gid
        packed = UniversalID::MessagePackFactory.pack(campaign.to_gid)
        unpacked = UniversalID::MessagePackFactory.unpack(packed)
        assert_equal expected, unpacked
      end
    end

    def test_signed_global_id
      with_persisted_campaign do |campaign|
        expected = campaign.to_sgid
        packed = UniversalID::MessagePackFactory.pack(campaign.to_sgid)
        unpacked = UniversalID::MessagePackFactory.unpack(packed)
        assert_equal expected, unpacked
      end
    end

    def test_implicit_global_id
      with_persisted_campaign do |campaign|
        packed = UniversalID::MessagePackFactory.pack(campaign)
        unpacked = UniversalID::MessagePackFactory.unpack(packed)
        assert_equal campaign, unpacked
      end
    end
  end
end
