# frozen_string_literal: true

require_relative "../../test_helper"

class URI::UID::GlobalIDTest < Minitest::Test
  def test_uid_to_and_from_global_id
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

  def test_uid_to_and_from_signed_global_id
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
