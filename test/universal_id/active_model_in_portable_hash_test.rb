# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::ActiveModelInPortableHashTest < ActiveSupport::TestCase
  def setup
    @campaign = Campaign.create!(name: "Example Campaign", description: "Example Description", trigger: "Example Trigger")
    @hash = UniversalID::PortableHash.new(
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
  end

  def teardown
    @campaign.destroy
  end

  def test_find
    assert_equal @hash, UniversalID::PortableHash.find(@hash.id)
  end

  def test_to_gid
    gid = @hash.to_gid

    expected = {"test" => true, "example" => "value", "nested" => {"keep" => "keep"}, "campaign" => @campaign}

    assert_equal expected, gid.find
  end

  def test_to_sgid
    sgid = @hash.to_sgid

    expected = {"test" => true, "example" => "value", "nested" => {"keep" => "keep"}, "campaign" => @campaign}

    assert_equal expected, sgid.find
  end
end
