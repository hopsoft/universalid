# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::NestedGlobalIDsTest < ActiveSupport::TestCase
  def setup
    @campaign = Campaign.find_or_create_by!(name: "Example Campaign", description: "Example Description", trigger: "Example Trigger")
    @portable_hash = UniversalID::PortableHash.new(
      test: true,
      example: "value",
      other: nil,
      nested: {
        keep: "keep",
        remove: "remove"
      },
      campaign: @campaign,
      portable_hash_options: {except: %w[remove]} # combines with config
    )
    @expected = {"test" => true, "example" => "value", "nested" => {"keep" => "keep"}, "campaign" => @campaign}
  end

  def teardown
    @campaign.destroy
  end

  def test_to_gid
    assert_equal @expected, @portable_hash.to_gid.find
  end

  def test_to_sgid
    assert_equal @expected, @portable_hash.to_sgid.find
  end

  def test_find_by_portable_hash_id
    assert_equal @expected, UniversalID::PortableHash.find(@portable_hash.id)
  end

  def test_parse_and_find_by_gid_param
    assert_equal @expected, UniversalID::PortableHash.parse_gid(@portable_hash.to_gid_param).find
  end

  def test_parse_and_find_by_sgid_param
    assert_equal @expected, UniversalID::PortableHash.parse_gid(@portable_hash.to_sgid_param).find
  end

  def test_parse_and_find_by_gid_deep
    a = UniversalID::PortableHash.new(
      test: true,
      nested: @portable_hash
    )

    assert UniversalID::PortableHash.possible_gid_string?(a["nested"])

    b = UniversalID::PortableHash.new(
      test: true,
      nested: a
    )

    assert UniversalID::PortableHash.possible_gid_string?(b["nested"])

    expected = {
      "test" => true,
      "nested" => {
        "test" => true,
        "nested" => {
          "test" => true,
          "example" => "value",
          "nested" => {"keep" => "keep"},
          "campaign" => @campaign
        }
      }
    }

    assert_equal expected, UniversalID::PortableHash.parse_gid(b.to_gid_param).find
  end

  def test_parse_and_find_by_sgid_deep
    a = UniversalID::PortableHash.new(
      test: true,
      nested: @portable_hash
    )

    assert UniversalID::PortableHash.possible_gid_string?(a["nested"])

    b = UniversalID::PortableHash.new(
      test: true,
      nested: a
    )

    assert UniversalID::PortableHash.possible_gid_string?(b["nested"])

    expected = {
      "test" => true,
      "nested" => {
        "test" => true,
        "nested" => {
          "test" => true,
          "example" => "value",
          "nested" => {"keep" => "keep"},
          "campaign" => @campaign
        }
      }
    }

    assert_equal expected, UniversalID::PortableHash.parse_gid(b.to_sgid_param).find
  end
end
