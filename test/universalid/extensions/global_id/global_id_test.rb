# frozen_string_literal: true

# class UniversalID::MessagePack::GlobalIDTest < Minitest::Test
# def test_global_id
# campaign = Campaign.forge!
# expected = campaign.to_gid
# packed = UniversalID::MessagePackFactory.pack(campaign.to_gid)
# unpacked = UniversalID::MessagePackFactory.unpack(packed)
# assert_equal expected, unpacked
# end
# end

# class URI::UID::GlobalIDTest < Minitest::Test
# def test_global_id
# product = {
# name: "Wireless Bluetooth Earbuds",
# price: 99.99,
# category: "Electronics"
# }

# uid = URI::UID.build(product)
# gid = uid.to_gid_param
# decoded = URI::UID.from_gid(gid).decode
# assert_equal product, decoded
# end
# end

# @!group UniversalID::Packer ##################################################

class UniversalID::Packer::GlobalIDTest < Minitest::Test
  def test_pack_unpack_with_hash
    value = {
      name: "Wireless Bluetooth Earbuds",
      price: 99.99,
      category: "Electronics"
    }
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal value, unpacked
  end

  def test_pack_unpack_with_model
    value = Campaign.forge!
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal value, unpacked
  end
end

# @!endgroup /UniversalID::Packer ##############################################

# @!group UniversalID::Encoder #################################################

class UniversalID::Encoder::GlobalIDTest < Minitest::Test
  def test_encode_decode_with_hash
    value = {
      name: "Wireless Bluetooth Earbuds",
      price: 99.99,
      category: "Electronics"
    }
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal value, decoded
  end

  def test_encode_decode_with_model
    value = Campaign.forge!
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal value, decoded
  end
end

# @!endgroup /UniversalID::Encoder #############################################

# @!group UniversalID::GlobalID ################################################

class URI::UID::GlobalIDTest < Minitest::Test
  # @!group Build, Parse, Decode ...............................................

  def test_build_parse_decode_with_hash
    value = {
      name: "Wireless Bluetooth Earbuds",
      price: 99.99,
      category: "Electronics"
    }
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_build_parse_decode_with_model
    value = Campaign.forge!
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert_equal value, decoded
  end

  # @!endgroup /Build, Parse, Decode ...........................................

  # @!group Global ID ..........................................................

  def test_global_id_with_hash
    value = {
      name: "Wireless Bluetooth Earbuds",
      price: 99.99,
      category: "Electronics"
    }
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_global_id_with_model
    value = Campaign.forge!
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  # @!endgroup /Global ID ......................................................

  # @!group Signed Global ID ...................................................

  def test_signed_global_id_with_hash
    value = {
      name: "Wireless Bluetooth Earbuds",
      price: 99.99,
      category: "Electronics"
    }
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_signed_global_id_with_model
    value = Campaign.forge!
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  # @!endgroup /Signed Global ID ...............................................
end

# @!endgroup UniversalID::GlobalID #############################################
