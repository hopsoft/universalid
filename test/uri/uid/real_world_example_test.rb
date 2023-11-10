# frozen_string_literal: true

require_relative "../../test_helper"

class URI::UID::RealWorldExampleTest < Minitest::Test
  def test_complex_data_structure
    # create some active record object
    campaign = Campaign.create!(name: "Demo 1", description: "Description 1")
    emails = [
      Email.create!(campaign: campaign, subject: Faker::Movie.title, body: Faker::Movie.quote),
      Email.create!(campaign: campaign, subject: Faker::Movie.title, body: Faker::Movie.quote)
    ]

    # create a complex data structure that embeds some active record objects
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

    # make some in-memory changes to campaign without saving them
    campaign.name = "Changed to Demo 2"
    campaign.description = "Changed to Description 2"

    # create the UID
    uid = URI::UID.build(data, include_blank: false, exclude: ["password"], include_unsaved_changes: true)

    # add a binding.pry here if you want to introspect the UID
    # it's pretty interesting, so I highly recommend doing this
    # binding.pry

    # parse and decode the UID
    decoded = URI::UID.parse(uid.to_s).decode

    # dig out the campaign for some assertions
    decoded_campaign = decoded.dig(:corporate, :campaigns).first

    # this is the expected decoded data structure given the args passed to URI::UID.build
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

    assert campaign.changed? # in-memory campaign was changed, but not saved
    assert decoded_campaign.changed? # marshaled campaign should preserve the changes
    assert_equal campaign.changes, decoded_campaign.changes # changes should be identical
  end
end
