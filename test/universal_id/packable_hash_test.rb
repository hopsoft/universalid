# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::HashTest < ActiveSupport::TestCase
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
    @packable_hash = UniversalID::PackableHash.new(@hash)
  end

  def test_packable_hash
    assert @hash, @packable_hash.to_h
  end

  def test_id
    assert_equal "eNprXlKSWlxyeHlqRWJuQU7q0rLEnNLUZXlAsdSUxiXZqakFYAIAdhkSPA", @packable_hash.id(except: %w[created_at updated_at remove])
  end

  def test_cache_key
    assert_equal "UniversalID::PackableHash/c0e15c990791eaa8c00b71a89444e4f2", @packable_hash.cache_key(except: %w[created_at updated_at remove])
  end

  def test_find_id
    expected = {test: true, example: "value", nested: {keep: "keep"}}
    actual = UniversalID::PackableHash.find(@packable_hash.id(except: %w[created_at updated_at remove]))
    assert_equal expected, actual.deep_symbolize_keys
  end

  def test_find_gid
    expected = {test: true, example: "value", nested: {keep: "keep"}}
    actual = UniversalID::PackableHash.find(@packable_hash.to_gid(uid: {except: %w[created_at updated_at remove]}))
    assert_equal expected, actual.deep_symbolize_keys
  end

  def test_find_gid_param
    expected = {test: true, example: "value", nested: {keep: "keep"}}
    actual = UniversalID::PackableHash.find(@packable_hash.to_gid_param(uid: {except: %w[created_at updated_at remove]}))
    assert_equal expected, actual.deep_symbolize_keys
  end

  def test_find_sgid
    expected = {test: true, example: "value", nested: {keep: "keep"}}
    actual = UniversalID::PackableHash.find(@packable_hash.to_sgid(uid: {except: %w[created_at updated_at remove]}))
    assert_equal expected, actual.deep_symbolize_keys
  end

  def test_find_sgid_param
    expected = {test: true, example: "value", nested: {keep: "keep"}}
    actual = UniversalID::PackableHash.find(@packable_hash.to_sgid_param(uid: {except: %w[created_at updated_at remove]}))
    assert_equal expected, actual.deep_symbolize_keys
  end

  def test_find_invalid
    invalid_id = SecureRandom.hex

    error = assert_raises(UniversalID::LocatorError) do
      UniversalID::PackableHash.find invalid_id
    end

    assert error.message.include?("Failed to locate the id")
    assert error.message.include?(invalid_id)
    assert_equal invalid_id, error.id
    assert error.cause
  end

  def test_id_with_allow_blank_option
    hash = {a: 1, b: 2, c: nil, d: [], e: {}}
    portable_hash = UniversalID::PackableHash.new(hash)

    # default (false)
    actual = UniversalID::PackableHash.find(portable_hash.id).to_h
    assert_equal hash.slice(:a, :b), actual.deep_symbolize_keys

    # true
    actual = UniversalID::PackableHash.find(portable_hash.id(allow_blank: true)).to_h
    assert_equal hash, actual.deep_symbolize_keys
  end

  def test_id_with_only_option
    hash = {a: 1, b: 2, c: 3}
    portable_hash = UniversalID::PackableHash.new(hash)
    expected = hash.slice(:a, :b)

    # symbol values
    actual = UniversalID::PackableHash.find(portable_hash.id(only: %i[a b])).to_h
    assert_equal expected, actual.deep_symbolize_keys

    # string values
    actual = UniversalID::PackableHash.find(portable_hash.id(only: %w[a b])).to_h
    assert_equal expected, actual.deep_symbolize_keys
  end

  def test_id_with_only_option_nested
    hash = {a: 1, b: 2, c: 3, z: {a: "nested"}}
    portable_hash = UniversalID::PackableHash.new(hash)
    expected = hash.slice(:a, :z)

    # symbol values
    actual = UniversalID::PackableHash.find(portable_hash.id(only: %i[a z])).to_h
    assert_equal expected, actual.deep_symbolize_keys

    # string values
    actual = UniversalID::PackableHash.find(portable_hash.id(only: %w[a z])).to_h
    assert_equal expected, actual.deep_symbolize_keys
  end

  def test_id_with_except_option
    hash = {a: 1, b: 2, c: 3}
    portable_hash = UniversalID::PackableHash.new(hash)
    expected = hash.slice(:a, :b)

    # symbol values
    actual = UniversalID::PackableHash.find(portable_hash.id(except: %i[c])).to_h
    assert_equal expected, actual.deep_symbolize_keys

    # string values
    actual = UniversalID::PackableHash.find(portable_hash.id(except: %w[c])).to_h
    assert_equal expected, actual.deep_symbolize_keys
  end

  def test_id_with_except_option_nested
    hash = {a: 1, b: 2, c: 3, d: {c: "nested"}}
    portable_hash = UniversalID::PackableHash.new(hash)
    expected = hash.slice(:a, :b)

    # symbol values
    actual = UniversalID::PackableHash.find(portable_hash.id(except: %i[c])).to_h
    assert_equal expected, actual.deep_symbolize_keys

    # string values
    actual = UniversalID::PackableHash.find(portable_hash.id(except: %w[c])).to_h
    assert_equal expected, actual.deep_symbolize_keys
  end

  def test_to_gid
    gid = @packable_hash.to_gid(uid: {except: %w[created_at updated_at remove]})

    expected = {
      uri: "gid://UniversalID/UniversalID::PackableHash/eNprXlKSWlxyeHlqRWJuQU7q0rLEnNLUZXlAsdSUxiXZqakFYAIAdhkSPA",
      param: "Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBhY2thYmxlSGFzaC9lTnByWGxLU1dseHllSGxxUldKdVFVN3EwckxFbk5MVVpYbEFzZFNVeGlYWnFha0ZZQUlBZGhrU1BB",
      hash: {"test" => true, "example" => "value", "nested" => {"keep" => "keep"}}
    }

    assert_equal expected[:uri], gid.to_s
    assert_equal expected[:param], gid.to_param
    assert_equal expected[:hash], gid.find.to_h
    assert_equal gid, GlobalID.parse(expected[:uri])
    assert_equal gid, GlobalID.parse(expected[:param])
  end

  def test_to_sgid
    sgid = @packable_hash.to_sgid(uid: {except: %w[created_at updated_at remove]})

    expected = {
      param: "eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJbXRuYVdRNkx5OVZibWwyWlhKellXeEpSQzlWYm1sMlpYSnpZV3hKUkRvNlVHRmphMkZpYkdWSVlYTm9MMlZPY0hKWWJFdFRWMng0ZVdWSWJIRlNWMHAxVVZVM2NUQnlURVZ1VGt4VldsaHNRWE5rVTFWNGFWaGFjV0ZyUmxsQlNVRmthR3RUVUVFR09nWkZWQT09IiwiZXhwIjpudWxsLCJwdXIiOiJkZWZhdWx0In19--c10543bab07e009450c50b945ce5add413ba44b6",
      hash: {"test" => true, "example" => "value", "nested" => {"keep" => "keep"}}
    }

    assert_equal expected[:param], sgid.to_s
    assert_equal expected[:param], sgid.to_param
    assert_equal expected[:hash], sgid.find.to_h
    assert_equal sgid, SignedGlobalID.parse(expected[:param])
  end
end
