# frozen_string_literal: true

class UniversalID::Packer::SymbolTest < Minitest::Test
  def test_pack_unpack
    value = :test_symbol
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal 14, packed.size
    assert_equal "\xC7\v\x00test_symbol".b, packed
    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::SymbolTest < Minitest::Test
  def test_encode_decode
    value = :test_symbol
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal 24, encoded.size
    assert_equal "iwaAxwsAdGVzdF9zeW1ib2wD", encoded
    assert_equal value, decoded
  end
end

class URI::UID::SymbolTest < Minitest::Test
  def test_build_parse_decode
    value = :test_symbol
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert uri.start_with?("uid://universalid/iwaAxwsAdGVzdF9zeW1ib2wD")
    assert_equal value, decoded
  end

  def test_global_id
    value = :test_symbol
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_signed_global_id
    value = :test_symbol
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value, decoded
  end
end
