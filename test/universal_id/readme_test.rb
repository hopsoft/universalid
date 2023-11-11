# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::ReadmeTest < Minitest::Test
  def new_campaign
    campaign = Campaign.new(
      name: "Summer Sale Campaign",
      description: "A campaign for the summer sale, targeting our loyal customers.",
      trigger: "SummerStart"
    )

    campaign.emails = 3.times.map do |i|
      email = campaign.emails.build(
        subject: "Summer Sale Special Offer #{i + 1}",
        body: "Dear Customer, check out our exclusive summer sale offers! #{i + 1}",
        wait: rand(1..14)
      )

      email.tap do |e|
        e.attachments = 2.times.map do |j|
          data = SecureRandom.random_bytes(rand(500..1500))
          e.attachments.build(
            file_name: "summer_sale_#{i + 1}_attachment_#{j + 1}.pdf",
            content_type: "application/pdf",
            file_size: data.size,
            file_data: data
          )
        end
      end
    end

    campaign
  end

  def assert_campaign(campaign)
    assert campaign.new_record?
    assert campaign.changed?
    assert_equal 3, campaign.emails.size

    campaign.emails.each do |email|
      assert email.new_record?
      assert email.changed?
      assert_equal 2, email.attachments.size

      email.attachments.each do |attachment|
        assert attachment.new_record?
        assert attachment.changed?
      end
    end
  end

  def test_readme
    campaign = new_campaign

    assert_campaign campaign

    options = {
      include_unsaved_changes: true,
      include_descendants: true,
      descendant_depth: 2
    }

    uid = URI::UID.build(campaign, options)
    copy = uid.decode

    assert_campaign copy
  end
end
