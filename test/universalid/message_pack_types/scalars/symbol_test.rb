# frozen_string_literal: true

class UniversalID::Packer::SymbolTest < Minitest::Test
  def test_pack_unpack
    expected = :test_symbol
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal 14, packed.size
    assert_equal "\xC7\v\x00test_symbol".b, packed
    assert_equal expected, actual
  end
end

class UniversalID::Encoder::SymbolTest < Minitest::Test
  def test_encode_decode
    expected = :test_symbol
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal 24, encoded.size
    assert_equal "iwaAxwsAdGVzdF9zeW1ib2wD", encoded
    assert_equal expected, actual
  end
end

class URI::UID::SymbolTest < Minitest::Test
  def test_build_parse_decode
    expected = :test_symbol
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert uri.start_with?("uid://universalid/iwaAxwsAdGVzdF9zeW1ib2wD")
    assert_equal expected, actual
  end

  def test_global_id
    expected = :test_symbol
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_signed_global_id
    expected = :test_symbol
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_equal expected, actual
  end
end
