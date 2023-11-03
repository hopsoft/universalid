# frozen_string_literal: true

require_relative "../test_helper"

module UniversalID::MessagePackTypes
  class UniversalIDTest < Minitest::Test
    def test_universal_id
      with_persisted_campaign do |campaign|
        payload = {number: 123, string: "data", array: [1, 2, 3], hash: {model: campaign}}
        uid = UniversalID::URI::UID.create(payload)
        assert uid.valid?
        packed = UniversalID::MessagePacker.pack(uid)
        unpacked = UniversalID::MessagePacker.unpack(packed)
        assert_equal uid, unpacked
      end
    end
  end
end
