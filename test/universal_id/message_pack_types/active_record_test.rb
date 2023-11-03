# frozen_string_literal: true

require_relative "../test_helper"

module UniversalID::MessagePackTypes
  class ActiveRecordTest < Minitest::Test
    def test_persisted_model
      with_persisted_campaign do |campaign|
        packed = UniversalID::MessagePacker.pack(campaign)
        unpacked = UniversalID::MessagePacker.unpack(packed)
        assert_equal campaign.attributes, unpacked.attributes
      end
    end

    def test_new_model
      with_new_campaign do |campaign|
        packed = UniversalID::MessagePacker.pack(campaign)
        unpacked = UniversalID::MessagePacker.unpack(packed)
        assert_equal campaign.attributes, unpacked.attributes
      end
    end
  end
end
