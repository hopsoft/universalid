# frozen_string_literal: true

require_relative "../test_helper"

module UniversalID::MessagePackTypes
  class ActiveRecordTest < Minitest::Test
    def test_persisted_model
      with_persisted_campaign do |campaign|
        actual = MessagePack.unpack(MessagePack.pack(campaign))
        assert_equal campaign.attributes, actual.attributes
      end
    end

    def test_new_model
      with_new_campaign do |campaign|
        actual = MessagePack.unpack(MessagePack.pack(campaign))
        assert_equal campaign.attributes, actual.attributes
      end
    end
  end
end
