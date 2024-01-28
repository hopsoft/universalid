# frozen_string_literal: true

class UniversalID::MessagePack::SignedGlobalIDTest < Minitest::Test
  def test_pack_and_unpack
    campaign = Campaign.forge!
    expected = campaign.to_sgid
    packed = UniversalID::MessagePackFactory.pack(campaign.to_sgid)
    unpacked = UniversalID::MessagePackFactory.unpack(packed)
    assert_equal expected, unpacked
  end
end

class URI::UID::SignedGlobalIDTest < Minitest::Test
  def test_build_parse_decode
    product = {
      name: "Wireless Bluetooth Headphones",
      price: 179.99,
      category: "Electronics"
    }

    uid = URI::UID.build(product)

    sgid = uid.to_sgid_param(for: "cart-123", expires_in: 1.hour)
    decoded = URI::UID.from_sgid(sgid, for: "cart-123").decode
    assert_equal product, decoded

    # test mismatched purpose
    assert_nil URI::UID.from_sgid(sgid, for: "cart-456")
  end
end
