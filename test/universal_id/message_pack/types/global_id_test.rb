# frozen_string_literal: true

require_relative "../../test_helper"

module UniversalID::MessagePack::Types
  class GlobalIDTest < ActiveSupport::TestCase
    setup do
      @campaign = Campaign.create(name: "Test Campaign")
    end

    def test_global_id
      expected = @campaign.to_gid
      actual = MessagePack.unpack(MessagePack.pack(@campaign.to_gid))
      assert_equal expected, actual
    end

    def test_signed_global_id
      expected = @campaign.to_sgid
      actual = MessagePack.unpack(MessagePack.pack(@campaign.to_sgid))
      assert_equal expected, actual
    end

    def test_implicit_global_id
      expected = @campaign
      actual = MessagePack.unpack(MessagePack.pack(@campaign))
      assert_equal expected, actual
    end
  end
end
