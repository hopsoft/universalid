# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::NestedGlobalIDsTest < ActiveSupport::TestCase
  def setup
    @campaign = Campaign.find_or_create_by!(name: "Example Campaign", description: "Example Description", trigger: "Example Trigger")
    @hash = {
      test: true,
      example: "value",
      other: nil,
      nested: {
        keep: "keep",
        remove: "remove"
      },
      campaign: @campaign
    }.deep_symbolize_keys
    @marshalable_hash = UniversalID::MarshalableHash.new(@hash)
    @expected = {test: true, example: "value", nested: {keep: "keep"}, campaign: @campaign}

    @nested_marshalable_hash = UniversalID::MarshalableHash.new(
      test: true,
      nested: UniversalID::MarshalableHash.new(
        test: true,
        nested: @marshalable_hash
      )
    )
    @nested_expected = {
      test: true,
      nested: {
        test: true,
        nested: {
          test: true,
          example: "value",
          nested: {"keep" => "keep"},
          campaign: @campaign
        }
      }
    }.deep_symbolize_keys
  end

  def teardown
    @campaign.destroy
  end

  def test_to_gid
    actual = @marshalable_hash.to_gid(uid: {except: %w[remove]}).find
    assert_equal @expected, actual.deep_symbolize_keys
  end

  def test_to_sgid
    actual = @marshalable_hash.to_sgid(uid: {except: %w[remove]}).find
    assert_equal @expected, actual.deep_symbolize_keys
  end

  def test_find_by_marshalable_hash_id
    actual = UniversalID::MarshalableHash.find(@marshalable_hash.id(except: %w[remove]))
    assert_equal @expected, actual.deep_symbolize_keys
  end

  def test_find_by_gid_param
    actual = UniversalID::MarshalableHash.find(@marshalable_hash.to_gid_param(uid: {except: %w[remove]}))
    assert_equal @expected, actual.deep_symbolize_keys
  end

  def test_find_by_sgid_param
    actual = UniversalID::MarshalableHash.find(@marshalable_hash.to_sgid_param(uid: {except: %w[remove]}))
    assert_equal @expected, actual.deep_symbolize_keys
  end

  def test_nested_find_by_id
    actual = UniversalID::MarshalableHash.find(@nested_marshalable_hash.id(except: %w[remove]))
    assert_equal @nested_expected, actual.deep_symbolize_keys
  end

  def test_nested_find_by_gid
    actual = UniversalID::MarshalableHash.find(@nested_marshalable_hash.to_gid_param(uid: {except: %w[remove]}))
    assert_equal @nested_expected, actual.deep_symbolize_keys
  end

  def test_nested_find_by_sgid
    actual = UniversalID::MarshalableHash.find(@nested_marshalable_hash.to_sgid_param(uid: {except: %w[remove]}))
    assert_equal @nested_expected, actual.deep_symbolize_keys
  end
end
