# frozen_string_literal: true

class UniversalID::MessagePack::GlobalIDTest < Minitest::Test
  def test_global_id
    campaign = Campaign.forge!
    expected = campaign.to_gid
    packed = UniversalID::MessagePackFactory.pack(campaign.to_gid)
    unpacked = UniversalID::MessagePackFactory.unpack(packed)
    assert_equal expected, unpacked
  end
end

class URI::UID::GlobalIDTest < Minitest::Test
  def test_global_id
    product = {
      name: "Wireless Bluetooth Earbuds",
      price: 99.99,
      category: "Electronics"
    }

    uid = URI::UID.build(product)
    gid = uid.to_gid_param
    decoded = URI::UID.from_gid(gid).decode
    assert_equal product, decoded
  end
end
