# frozen_string_literal: true

require_relative "../../test_helper"

class URI::UID::RealWorldExamplesTest < Minitest::Test
  def test_hash_with_prepack_options
    campaign = Campaign.create!(name: "Demo 1", description: "Description 1")
    emails = [
      Email.create!(campaign: campaign, subject: Faker::Movie.title, body: Faker::Movie.quote),
      Email.create!(campaign: campaign, subject: Faker::Movie.title, body: Faker::Movie.quote)
    ]

    data = {
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      password: "Secret123ABC",
      corporate: {
        company: nil,
        details: {},
        reports: [],
        campaigns: [campaign]
      },
      emails: emails
    }

    uid = URI::UID.create(data, include_blank: false, exclude: ["password"])
    decoded = URI::UID.parse(uid.to_s).decode

    expected = {
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      corporate: {
        campaigns: [campaign]
      },
      emails: emails
    }

    assert_equal expected, decoded
  end
end
