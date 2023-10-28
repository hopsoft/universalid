# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::PackableHashTest < ActiveSupport::TestCase
  def setup
    @hash = {
      test: true,
      example: "value",
      other: nil,
      created_at: Time.current,
      updated_at: Time.current,
      nested: {
        keep: "keep",
        remove: "remove"
      }
    }
    @packable = UniversalID::PackableHash.new(@hash)
  end

  def test_config
    expected = {
      to_packable_options: {
        allow_blank: false,
        only: [], # keys to include (trumps except)
        except: [] # keys to exclude
      }
    }

    assert expected, UniversalID::PackableHash.config
  end

  def test_marshalable_hash
    assert @hash, @packable.to_h
  end

  def test_pack
    expected = "eNprXlKSWlxyeHlqRWJuQU7q0rLEnNLUZXlAsdSUxiXZqakFYAIAdhkSPA"
    actual = @packable.pack(except: %w[created_at updated_at remove])
    assert_equal expected, actual
  end

  def test_to_uri
    expected = "uid://universal_id/universal_id-packable_hash/eNprXlKSWlxyeHlqRWJuQU7q0rLEnNLUZXlAsdSUxiXZqakFYAIAdhkSPA"
    actual = @packable.to_uri(except: %w[created_at updated_at remove]).to_s
    assert_equal expected, actual
  end

  def test_unpack_string
    packed = @packable.pack(except: %w[created_at updated_at remove])
    hash = UniversalID::PackableHash.unpack(packed)
    expected = {
      "test" => true,
      "example" => "value",
      "nested" => {"keep" => "keep"}
    }

    assert hash.is_a?(UniversalID::PackableHash)
    assert_equal expected, hash.to_h
  end

  # def test_to_gid
  # expected = "gid://UniversalID/UniversalID::PackableObject/eNprXlKSWlxyeHlqRWJuQU7q0rLEnNLUZXlAsdSUxiXZqakFYAIAdhkSPA"
  # actual = @marshalable_hash.to_gid(packable_options: {except: %w[created_at updated_at remove]}).to_s
  # assert_equal expected, actual
  # end

  # def test_find_by_gid
  # gid = @marshalable_hash.to_gid(packable_options: {except: %w[created_at updated_at remove]}).to_s
  # hash = UniversalID::MarshalableHash.find(gid)
  # expected = {
  # "test" => true,
  # "example" => "value",
  # "nested" => {"keep" => "keep"}
  # }

  # assert hash.is_a?(UniversalID::MarshalableHash)
  # assert_equal expected, hash.to_h
  # end

  # def test_to_packable_gid_param
  # expected = "Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBhY2thYmxlT2JqZWN0L2VOcHJYbEtTV2x4eWVIbHFSV0p1UVU3cTByTEVuTkxVWlhsQXNkU1V4aVhacWFrRllBSUFkaGtTUEE"
  # actual = @marshalable_hash.to_gid_param(packable_options: {except: %w[created_at updated_at remove]})
  # assert_equal expected, actual
  # end

  # def test_find_by_gid_param
  # gid = @marshalable_hash.to_gid_param(packable_options: {except: %w[created_at updated_at remove]})
  # hash = UniversalID::MarshalableHash.find(gid)
  # expected = {
  # "test" => true,
  # "example" => "value",
  # "nested" => {"keep" => "keep"}
  # }

  # assert hash.is_a?(UniversalID::MarshalableHash)
  # assert_equal expected, hash.to_h
  # end

  # def test_to_packable_sgid
  # expected = "eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJbTFuYVdRNkx5OVZibWwyWlhKellXeEpSQzlWYm1sMlpYSnpZV3hKUkRvNlVHRmphMkZpYkdWUFltcGxZM1F2WlU1d2NsaHNTMU5YYkhoNVpVaHNjVkpYU25WUlZUZHhNSEpNUlc1T1RGVmFXR3hCYzJSVFZYaHBXRnB4WVd0R1dVRkpRV1JvYTFOUVFRWTZCa1ZVIiwiZXhwIjpudWxsLCJwdXIiOiJkZWZhdWx0In19--81ca4dfa0ba24bb922c6aeb0401ac5d5be66c231"
  # actual = @marshalable_hash.to_sgid(packable_options: {except: %w[created_at updated_at remove]}).to_s
  # assert_equal expected, actual
  # end

  # def test_find_by_sgid
  # sgid = @marshalable_hash.to_sgid(packable_options: {except: %w[created_at updated_at remove]}).to_s
  # hash = UniversalID::MarshalableHash.find(sgid)
  # expected = {
  # "test" => true,
  # "example" => "value",
  # "nested" => {"keep" => "keep"}
  # }

  # assert hash.is_a?(UniversalID::MarshalableHash)
  # assert_equal expected, hash.to_h
  # end

  # def test_to_packable_sgid_param
  # expected = "eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJbTFuYVdRNkx5OVZibWwyWlhKellXeEpSQzlWYm1sMlpYSnpZV3hKUkRvNlVHRmphMkZpYkdWUFltcGxZM1F2WlU1d2NsaHNTMU5YYkhoNVpVaHNjVkpYU25WUlZUZHhNSEpNUlc1T1RGVmFXR3hCYzJSVFZYaHBXRnB4WVd0R1dVRkpRV1JvYTFOUVFRWTZCa1ZVIiwiZXhwIjpudWxsLCJwdXIiOiJkZWZhdWx0In19--81ca4dfa0ba24bb922c6aeb0401ac5d5be66c231"
  # actual = @marshalable_hash.to_sgid_param(packable_options: {except: %w[created_at updated_at remove]})
  # assert_equal expected, actual
  # end

  # def test_find_by_sgid_param
  # sgid = @marshalable_hash.to_sgid_param(packable_options: {except: %w[created_at updated_at remove]})
  # hash = UniversalID::MarshalableHash.find(sgid)
  # expected = {
  # "test" => true,
  # "example" => "value",
  # "nested" => {"keep" => "keep"}
  # }

  # assert hash.is_a?(UniversalID::MarshalableHash)
  # assert_equal expected, hash.to_h
  # end

  # def test_find_invalid
  # invalid_id = SecureRandom.hex

  # error = assert_raises(UniversalID::LocatorError) do
  # UniversalID::MarshalableHash.find invalid_id
  # end

  # assert error.message.include?("Failed to locate the id")
  # assert error.message.include?(invalid_id)
  # assert_equal invalid_id, error.id
  # assert error.cause
  # end

  # def test_id_with_allow_blank_option
  # hash = {a: 1, b: 2, c: nil, d: [], e: {}}
  # packable = UniversalID::MarshalableHash.new(hash).to_packable

  ## default (false)
  # actual = packable.object.deep_symbolize_keys
  # assert_equal hash.slice(:a, :b), actual

  # actual = UniversalID::MarshalableHash.find(packable.id).to_h.deep_symbolize_keys
  # assert_equal hash.slice(:a, :b), actual

  ## true
  # packable = UniversalID::MarshalableHash.new(hash).to_packable(allow_blank: true)

  # actual = packable.object.deep_symbolize_keys
  # assert_equal hash, actual

  # actual = UniversalID::MarshalableHash.find(packable.id).to_h.deep_symbolize_keys
  # assert_equal hash, actual
  # end

  # def test_id_with_only_option
  # hash = {a: 1, b: 2, c: 3}
  # expected = hash.slice(:a, :b)

  ## symbol values
  # packable = UniversalID::MarshalableHash.new(hash).to_packable(only: %i[a b])

  # actual = packable.object.deep_symbolize_keys
  # assert_equal expected, actual

  # actual = UniversalID::MarshalableHash.find(packable.id).to_h.deep_symbolize_keys
  # assert_equal expected, actual

  ## string values
  # packable = UniversalID::MarshalableHash.new(hash).to_packable(only: %w[a b])

  # actual = packable.object.deep_symbolize_keys
  # assert_equal expected, actual

  # actual = UniversalID::MarshalableHash.find(packable.id).to_h
  # assert_equal expected, actual.deep_symbolize_keys
  # end

  # def test_id_with_only_option_nested
  # hash = {a: 1, b: 2, c: 3, z: {a: "nested"}}
  # expected = hash.slice(:a, :z)

  ## symbol values
  # packable = UniversalID::MarshalableHash.new(hash).to_packable(only: %i[a z])

  # actual = packable.object.deep_symbolize_keys
  # assert_equal expected, actual

  # actual = UniversalID::MarshalableHash.find(packable.id).to_h.deep_symbolize_keys
  # assert_equal expected, actual

  ## string values
  # packable = UniversalID::MarshalableHash.new(hash).to_packable(only: %w[a z])

  # actual = packable.object.deep_symbolize_keys
  # assert_equal expected, actual

  # actual = UniversalID::MarshalableHash.find(packable.id).to_h.deep_symbolize_keys
  # assert_equal expected, actual
  # end

  # def test_id_with_except_option
  # hash = {a: 1, b: 2, c: 3}
  # expected = hash.slice(:a, :b)

  ## symbol values
  # packable = UniversalID::MarshalableHash.new(hash).to_packable(except: %i[c])

  # actual = packable.object.deep_symbolize_keys
  # assert_equal expected, actual

  # actual = UniversalID::MarshalableHash.find(packable.id).to_h.deep_symbolize_keys
  # assert_equal expected, actual

  ## string values
  # packable = UniversalID::MarshalableHash.new(hash).to_packable(except: %w[c])

  # actual = packable.object.deep_symbolize_keys
  # assert_equal expected, actual

  # actual = UniversalID::MarshalableHash.find(packable.id).to_h.deep_symbolize_keys
  # assert_equal expected, actual
  # end

  ## def test_id_with_except_option_nested
  ##   hash = {a: 1, b: 2, c: 3, d: {c: "nested"}}
  ##   marshalable_hash = UniversalID::MarshalableHash.new(hash)
  ##   expected = hash.slice(:a, :b)

  ##   # symbol values
  ##   actual = UniversalID::MarshalableHash.find(marshalable_hash.id(except: %i[c])).to_h
  ##   assert_equal expected, actual.deep_symbolize_keys

  ##   # string values
  ##   actual = UniversalID::MarshalableHash.find(marshalable_hash.id(except: %w[c])).to_h
  ##   assert_equal expected, actual.deep_symbolize_keys
  ## end

  ## def test_to_gid
  ##  gid = @marshalable_hash.to_gid(uid: {except: %w[created_at updated_at remove]})

  ##  expected = {
  ##    uri: "gid://UniversalID/UniversalID::MarshalableHash/eNprXlKSWlxyeHlqRWJuQU7q0rLEnNLUZXlAsdSUxiXZqakFYAIAdhkSPA",
  ##    param: "Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBhY2thYmxlSGFzaC9lTnByWGxLU1dseHllSGxxUldKdVFVN3EwckxFbk5MVVpYbEFzZFNVeGlYWnFha0ZZQUlBZGhrU1BB",
  ##    hash: {"test" => true, "example" => "value", "nested" => {"keep" => "keep"}}
  ##  }

  ##  binding.pry

  ##  assert_equal expected[:uri], gid.to_s
  ##  assert_equal expected[:param], gid.to_param
  ##  assert_equal expected[:hash], gid.find.to_h
  ##  assert_equal gid, GlobalID.parse(expected[:uri])
  ##  assert_equal gid, GlobalID.parse(expected[:param])
  ## end

  ## def test_to_sgid
  ##  sgid = @marshalable_hash.to_sgid(uid: {except: %w[created_at updated_at remove]})

  ##  expected = {
  ##    param: "eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJbXRuYVdRNkx5OVZibWwyWlhKellXeEpSQzlWYm1sMlpYSnpZV3hKUkRvNlVHRmphMkZpYkdWSVlYTm9MMlZPY0hKWWJFdFRWMng0ZVdWSWJIRlNWMHAxVVZVM2NUQnlURVZ1VGt4VldsaHNRWE5rVTFWNGFWaGFjV0ZyUmxsQlNVRmthR3RUVUVFR09nWkZWQT09IiwiZXhwIjpudWxsLCJwdXIiOiJkZWZhdWx0In19--c10543bab07e009450c50b945ce5add413ba44b6",
  ##    hash: {"test" => true, "example" => "value", "nested" => {"keep" => "keep"}}
  ##  }

  ##  assert_equal expected[:param], sgid.to_s
  ##  assert_equal expected[:param], sgid.to_param
  ##  assert_equal expected[:hash], sgid.find.to_h
  ##  assert_equal sgid, SignedGlobalID.parse(expected[:param])
  ## end
end
