# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::ReadmeTest < Minitest::Test
  def test_unsaved_changes_on_new_records
    campaign = new_campaign

    assert_new_record campaign

    options = {
      include_unsaved_changes: true,
      include_descendants: true,
      descendant_depth: 2
    }

    encoded = URI::UID.build(campaign, options).to_s
    decoded = URI::UID.parse(encoded).decode

    assert_new_record decoded
  end

  def test_unsaved_changes_on_persisted_records
    campaign = new_campaign
    campaign.save!

    assert_persisted_record campaign

    campaign.name = "Campaign #{SecureRandom.hex}"
    campaign.emails.each do |email|
      email.subject = "Email #{SecureRandom.hex}"
      email.attachments.each do |attachment|
        attachment.file_name = "Attachment-#{SecureRandom.hex}.pdf"
      end
    end

    options = {
      include_unsaved_changes: true,
      include_descendants: true,
      descendant_depth: 2
    }

    encoded = URI::UID.build(campaign, options).to_s
    decoded = URI::UID.parse(encoded).decode

    assert_persisted_record decoded, changes_expected: true
  end

  def test_copy_persisted_records
    campaign = new_campaign
    campaign.save!

    assert_persisted_record campaign

    options = {
      include_keys: false,
      include_timestamps: false,
      include_unsaved_changes: true,
      include_descendants: true,
      descendant_depth: 2
    }

    encoded = URI::UID.build(campaign, options).to_s
    decoded = URI::UID.parse(encoded).decode

    assert_new_record decoded
    decoded.save!
    assert_persisted_record decoded

    refute_equal campaign.id, decoded.id

    campaign.emails.each do |email|
      assert (campaign.emails.map(&:id) & decoded.emails.map(&:id)).none?
      assert (campaign.emails.map(&:attachments).flatten.map(&:id) & decoded.emails.map(&:attachments).flatten.map(&:id)).none?
    end
  end

  def test_active_record_relation
    email_subjects = [
      "Unlock Your Exclusive Member Discounts Today!",
      "Flash Sale Alert: 50% Off All Items – Today Only!",
      "Join Our Loyalty Program for Special Rewards",
      "New Arrivals You Can't Miss – Shop Now!"
    ]
    Campaign.create_for_test(50) do |campaign, i|
      campaign.emails = Email.create_for_test(5, subject: "#{email_subjects.sample} #{i + 1}")
    end

    relation = Campaign.joins(:emails).where("emails.subject LIKE ?", "%Exclusive%")

    # force load the relation
    relation.load
    assert relation.loaded?

    encoded = URI::UID.build(relation).to_s
    decoded = URI::UID.parse(encoded).decode

    assert decoded.is_a?(ActiveRecord::Relation)
    refute decoded.loaded?
    assert_equal relation, decoded
    assert_equal relation.size, decoded.size
  end

  private

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

  def assert_new_record(campaign)
    assert campaign.new_record?
    assert campaign.changed?
    assert_equal 3, campaign.emails.size
    assert campaign.emails.loaded?

    campaign.emails.each do |email|
      assert email.new_record?
      assert email.changed?
      assert_equal 2, email.attachments.size
      assert email.attachments.loaded?

      email.attachments.each do |attachment|
        assert attachment.new_record?
        assert attachment.changed?
      end
    end
  end

  def assert_persisted_record(campaign, changes_expected: false)
    assert campaign.persisted?
    assert campaign.changed? if changes_expected
    assert_equal 3, campaign.emails.size
    assert campaign.emails.loaded?

    campaign.emails.each do |email|
      assert email.persisted?
      assert email.changed? if changes_expected
      assert_equal 2, email.attachments.size
      assert email.attachments.loaded?

      email.attachments.each do |attachment|
        assert attachment.persisted?
        assert attachment.changed? if changes_expected
      end
    end
  end
end
