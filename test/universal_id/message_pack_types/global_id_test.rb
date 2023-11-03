# frozen_string_literal: true

require_relative "../test_helper"

module UniversalID::MessagePackTypes
  class GlobalIDTest < Minitest::Test
    def test_global_id
      with_persisted_campaign do |campaign|
        expected = campaign.to_gid
        packed = UniversalID::MessagePacker.pack(campaign.to_gid)
        unpacked = UniversalID::MessagePacker.unpack(packed)
        assert_equal expected, unpacked
      end
    end

    def test_signed_global_id
      with_persisted_campaign do |campaign|
        expected = campaign.to_sgid
        packed = UniversalID::MessagePacker.pack(campaign.to_sgid)
        unpacked = UniversalID::MessagePacker.unpack(packed)
        assert_equal expected, unpacked
      end
    end

    def test_implicit_global_id
      with_persisted_campaign do |campaign|
        packed = UniversalID::MessagePacker.pack(campaign)
        unpacked = UniversalID::MessagePacker.unpack(packed)
        assert_equal campaign, unpacked
      end
    end
  end
end
