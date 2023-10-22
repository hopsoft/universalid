# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::NestedGlobalIDsTest < ActiveSupport::TestCase
  def setup
    UniversalID.config[:hash][:except] = %w[remove]
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
    }
    @packable_hash = UniversalID::PackableHash.new(@hash)
    @expected = {test: true, example: "value", nested: {keep: "keep"}, campaign: @campaign}

    @nested_packable_hash = UniversalID::PackableHash.new(
      test: true,
      nested: UniversalID::PackableHash.new(
        test: true,
        nested: @packable_hash
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
    }
  end

  def teardown
    @campaign.destroy
  end

  def test_to_gid
    assert_equal @expected, @packable_hash.to_gid.find
  end

  def test_to_sgid
    assert_equal @expected, @packable_hash.to_sgid.find
  end

  def test_find_by_packable_hash_id
    assert_equal @expected, UniversalID::PackableHash.find(@packable_hash.id)
  end

  def test_find_by_gid_param
    assert_equal @expected, GlobalID.parse(@packable_hash.to_gid_param).find
  end

  def test_find_by_sgid_param
    assert_equal @expected, SignedGlobalID.parse(@packable_hash.to_sgid_param).find
  end

  def test_nested_find_by_id
    assert_equal @nested_expected, UniversalID::PackableHash.find(@nested_packable_hash.id)
  end

  def test_nested_find_by_gid
    assert_equal @nested_expected, GlobalID.parse(@nested_packable_hash.to_gid_param).find
  end

  def test_nested_find_by_sgid
    assert_equal @nested_expected, SignedGlobalID.parse(@nested_packable_hash.to_sgid_param).find
  end
end
