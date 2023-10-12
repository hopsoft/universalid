# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::ActiveModelInPortableHashTest < ActiveSupport::TestCase
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
      campaign: @campaign,
      portable_hash_options: {except: %w[remove]} # combines with config
    }
    @portable_hash = UniversalID::PortableHash.new(@hash)
  end

  def teardown
    @campaign.destroy
  end

  def test_find
    expected = {"test" => true, "example" => "value", "nested" => {"keep" => "keep"}, "campaign" => @campaign}
    assert_equal expected, UniversalID::PortableHash.find(@portable_hash.id)
  end

  def test_to_gid
    gid = @portable_hash.to_gid
    expected = {"test" => true, "example" => "value", "nested" => {"keep" => "keep"}, "campaign" => @campaign}
    assert_equal expected, gid.find
  end

  def test_to_sgid
    expected = {"test" => true, "example" => "value", "nested" => {"keep" => "keep"}, "campaign" => @campaign}
    assert_equal expected, @portable_hash.to_sgid.find
  end
end
