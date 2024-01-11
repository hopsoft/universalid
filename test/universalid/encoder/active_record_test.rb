# frozen_string_literal: true

class UniversalID::Encoder::ActiveRecordTest < Minitest::Test
  def test_new_model_exclude_changes
    campaign = Campaign.forge
    encoded = UniversalID::Encoder.encode(campaign)
    decoded = UniversalID::Encoder.decode(encoded)
    assert_equal campaign.class, decoded.class
    refute_equal campaign.attributes, decoded.attributes
    assert_empty decoded.attributes.compact
  end

  def test_new_model_include_changes
    campaign = Campaign.forge
    encoded = UniversalID::Encoder.encode(campaign, include_changes: true)
    decoded = UniversalID::Encoder.decode(encoded)
    assert_equal campaign.class, decoded.class
    assert_equal campaign.attributes, decoded.attributes
  end

  def test_new_model_include_changes_exclude_blanks
    campaign = Campaign.forge
    encoded = UniversalID::Encoder.encode(campaign, include_changes: true, include_blank: false)
    decoded = UniversalID::Encoder.decode(encoded)
    assert_equal campaign.class, decoded.class
    assert_equal campaign.attributes, decoded.attributes
  end

  def test_persisted_model
    campaign = Campaign.forge!
    encoded = UniversalID::Encoder.encode(campaign)
    decoded = UniversalID::Encoder.decode(encoded)
    assert_equal campaign, decoded
  end

  def test_persisted_model_marked_for_destruction
    campaign = Campaign.forge!
    campaign.mark_for_destruction
    encoded = UniversalID::Encoder.encode(campaign)
    decoded = UniversalID::Encoder.decode(encoded)
    assert_equal campaign, decoded
    assert decoded.marked_for_destruction?
  end

  def test_changed_persisted_model
    campaign = Campaign.forge!
    campaign.description = "Changed Description"
    encoded = UniversalID::Encoder.encode(campaign)
    decoded = UniversalID::Encoder.decode(encoded)
    assert_equal campaign, decoded
    refute_equal campaign.description, decoded.description
  end

  def test_changed_persisted_model_include_changes
    campaign = Campaign.forge!
    campaign.description = "Changed Description"
    encoded = UniversalID::Encoder.encode(campaign, include_changes: true)
    decoded = UniversalID::Encoder.decode(encoded)
    assert_equal campaign, decoded
    assert_equal campaign.description, decoded.description
  end

  def test_changed_persisted_model_with_registered_custom_config
    yaml = <<~YAML
      prepack:
        exclude:
          - description
          - trigger
        include_blank: false

        database:
          include_changes: true
          include_timestamps: false
    YAML

    _, settings = UniversalID::Settings.register("test_#{SecureRandom.alphanumeric(8)}", YAML.safe_load(yaml))

    campaign = Campaign.forge!
    # remember orig values
    description = campaign.description
    trigger = campaign.trigger

    # change values
    campaign.name = "Changed Name"
    campaign.description = "Changed Description"
    campaign.trigger = "Changed Trigger"

    encoded = UniversalID::Encoder.encode(campaign, **settings)
    decoded = UniversalID::Encoder.decode(encoded)

    # same record
    assert_equal campaign, decoded

    # included values match
    assert_equal campaign.name, decoded.name

    # excluded values do not match the in-memory changes
    refute_equal campaign.description, decoded.description
    refute_equal campaign.trigger, decoded.trigger

    # excluded values match the original values
    assert_equal description, decoded.description
    assert_equal trigger, decoded.trigger
  end

  def test_persisted_model_deep_copy_with_unsaved_descendants
    campaign = Campaign.forge!
    emails = 3.times.map { |i| campaign.emails.build subject: "Unsaved Email: #{i}" }
    emails.each do |email|
      2.times { email.attachments.build file_name: "Unsaved Attachment: #{email.subject}" }
    end

    options = {
      include_changes: true,
      include_descendants: true,
      descendant_depth: 2
    }

    encoded = UniversalID::Encoder.encode(campaign, **options)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal campaign, decoded

    emails.each do |email|
      decoded_email = decoded.emails.find { |e| e.subject == email.subject }
      assert decoded_email

      email.attachments.each do |attachment|
        decoded_attachment = decoded_email.attachments.find { |a| a.file_name == attachment.file_name }
        assert decoded_attachment
      end
    end
  end

  def test_persisted_model_deep_copy_customized
    campaign = Campaign.forge! emails: 3, attachments: 2

    options = {
      include_blank: false,
      exclude: [:description, :body, :file_data],
      include_keys: false,
      include_timestamps: false,
      include_changes: false,
      include_descendants: true,
      descendant_depth: 2
    }

    encoded = UniversalID::Encoder.encode(campaign, options)
    decoded = UniversalID::Encoder.decode(encoded)

    # verify decoded records also have changes
    assert decoded.changed?
    assert decoded.emails.map(&:changed?)
    assert decoded.emails.map(&:attachments).flatten.map(&:changed?)

    # verify that the in-memory and decoded records are different
    refute_equal campaign, decoded
    refute_equal campaign.emails, decoded.emails
    refute_equal campaign.emails.map(&:attachments), decoded.emails.map(&:attachments)

    # verify that the in-memory decoded records do not have keys or excluded fields
    assert_nil decoded.id
    assert_nil decoded.description
    decoded.emails.each do |email|
      assert_nil email.id
      assert_nil email.campaign_id
      assert_nil email.body
      email.attachments.each do |attachment|
        assert_nil attachment.id
        assert_nil attachment.email_id
        assert_nil attachment.file_data
      end
    end

    # verify that we can save the new records
    assert decoded.save
    assert decoded.emails.map(&:persisted?)
    assert decoded.emails.map(&:attachments).flatten.map(&:persisted?)
  end
end
