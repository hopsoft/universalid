# frozen_string_literal: true

class UniversalID::Packer::StructTest < Minitest::Test
  def test_pack_unpack_dynamic
    value = Struct.new(*scalars.keys).new(*scalars.values)
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal value.to_h, unpacked.to_h
  end

  class Scalars < Struct.new(*scalars.keys); end

  def test_pack_unpack_concrete
    value = Scalars.new(*scalars.values)
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::StructTest < Minitest::Test
  def test_encode_decode_dynamic
    value = Struct.new(*scalars.keys).new(*scalars.values)
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal value.to_h, decoded.to_h
  end

  class Scalars < Struct.new(*scalars.keys); end

  def test_encode_decode_concrete
    value = Scalars.new(*scalars.values)
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal value, decoded
  end
end

class URI::UID::StructTest < Minitest::Test
  def test_build_parse_decode_dynamic
    value = Struct.new(*scalars.keys).new(*scalars.values)
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert_equal value.to_h, decoded.to_h
  end

  def test_global_id_dynamic
    value = Struct.new(*scalars.keys).new(*scalars.values)
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value.to_h, decoded.to_h
  end

  def test_signed_global_id_dynamic
    value = Struct.new(*scalars.keys).new(*scalars.values)
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value.to_h, decoded.to_h
  end

  class Scalars < Struct.new(*scalars.keys); end

  def test_build_parse_decode_concrete
    value = Scalars.new(*scalars.values)
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_global_id_concrete
    value = Scalars.new(*scalars.values)
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_signed_global_id_concrete
    value = Scalars.new(*scalars.values)
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value, decoded
  end
end
