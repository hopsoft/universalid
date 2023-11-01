# frozen_string_literal: true

require_relative "../test_helper"

module UniversalID::MessagePackTypes
  class GlobalIDTest < ActiveSupport::TestCase
    def test_global_id
      with_persisted_campaign do |campaign|
        expected = campaign.to_gid
        actual = MessagePack.unpack(MessagePack.pack(campaign.to_gid))
        assert_equal expected, actual
      end
    end

    def test_signed_global_id
      with_persisted_campaign do |campaign|
        expected = campaign.to_sgid
        actual = MessagePack.unpack(MessagePack.pack(campaign.to_sgid))
        assert_equal expected, actual
      end
    end

    def test_implicit_global_id
      with_persisted_campaign do |campaign|
        actual = MessagePack.unpack(MessagePack.pack(campaign))
        assert_equal campaign, actual
      end
    end
  end
end
