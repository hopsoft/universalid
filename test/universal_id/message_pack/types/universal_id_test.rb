# frozen_string_literal: true

require_relative "../../test_helper"

module UniversalID::MessagePackUtils::Types
  class UniversalIDTest < ActiveSupport::TestCase
    def test_universal_id
      with_persisted_campaign do |campaign|
        payload = {number: 123, string: "data", array: [1, 2, 3], hash: {model: campaign}}
        uid = UniversalID::URI::UID.create(payload)
        assert uid.valid?
        assert uid.decodable?
        actual = MessagePack.unpack(MessagePack.pack(uid))
        assert_equal uid, actual
      end
    end
  end
end
