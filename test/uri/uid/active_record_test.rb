# frozen_string_literal: true

class URI::UID::ActiveRecordTest < Minitest::Test
  def test_new_model_exclude_changes
    campaign = Campaign.forge
    uid = URI::UID.build(campaign)
    decoded = URI::UID.parse(uid.to_s).decode
    assert_equal campaign.class, decoded.class
    refute_equal campaign.attributes, decoded.attributes
    assert_empty decoded.attributes.compact
  end

  def test_new_model_include_changes
    campaign = Campaign.forge
    uid = URI::UID.build(campaign, include_changes: true)
    decoded = URI::UID.parse(uid.to_s).decode
    assert_equal campaign.class, decoded.class
    assert_equal campaign.attributes, decoded.attributes
  end

  def test_new_model_include_changes_exclude_blanks
    campaign = Campaign.forge
    uid = URI::UID.build(campaign, include_changes: true, include_blank: false)
    decoded = URI::UID.parse(uid.to_s).decode
    assert_equal campaign.class, decoded.class
    assert_equal campaign.attributes, decoded.attributes
  end

  def test_persisted_model
    campaign = Campaign.forge!
    uid = URI::UID.build(campaign)
    decoded = URI::UID.parse(uid.to_s).decode
    assert_equal campaign, decoded
  end

  def test_persisted_model_marked_for_destruction
    campaign = Campaign.forge!
    campaign.mark_for_destruction
    uid = URI::UID.build(campaign)
    decoded = URI::UID.parse(uid.to_s).decode
    assert_equal campaign, decoded
    assert decoded.marked_for_destruction?
  end

  def test_changed_persisted_model
    campaign = Campaign.forge!
    campaign.description = "Changed Description"
    uid = URI::UID.build(campaign)
    decoded = URI::UID.parse(uid.to_s).decode
    assert_equal campaign, decoded
    refute_equal campaign.description, decoded.description
  end

  def test_changed_persisted_model_include_changes
    campaign = Campaign.forge!
    campaign.description = "Changed Description"
    uid = URI::UID.build(campaign, include_changes: true)
    decoded = URI::UID.parse(uid.to_s).decode
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

    uid = URI::UID.build(campaign, **settings)
    decoded = URI::UID.parse(uid.to_s).decode

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

  # UIDs are implicitly "fingerprinted" based on the mtime (UTC) of the file that defined the object's class
  # Fingerprint components are automatically decoded and yielded to the optional decode block
  #
  # Fingerprint Components:
  # 1. `Class (Class)`  - The encoded object's class
  # 2. `Timestamp (Time)` - The mtime (UTC) of the file that defined the object's class
  #
  # NOTE: The mtime timestamp will be nil for Ruby primitives
  #
  def test_persisted_model_with_custom_encode_and_decode_handlers
    campaign = Campaign.forge!

    # take control of encoding the uid payload to handle fingerprinting
    # (i.e. implicit versioning based on the mtime of the model definition)
    uid = URI::UID.build(campaign) do |record, options|
      # NOTE: record == campaign (i.e. the 2nd arg is the object being converted to a uid)

      # show an example of modifying the options
      options[:include] = %w[id custom]

      # create a specialized payload to be encoded
      # also, add something custom for demo purposes (note: this is not required)
      data = {id: record.id, demo: true}

      # encode just the attributes hash (this will become the uid payload)
      URI::UID.encode data, options.merge(include: %w[id demo])
    end

    decoded = URI::UID.parse(uid.to_s).decode do |data, klass, timestamp|
      record = klass.find_by(id: data[:id])
      record.instance_variable_set(:@demo, data[:demo])

      case timestamp
      when 3.months.ago..Time.now
        # current data format, return the record as-is
        record
      when 1.year.ago..3.months.ago
        # outdated data format
        # apply an ETL process to map the older data format to the current data format
        # return the modified record when finished
        record
      end
    end

    assert_equal campaign, decoded
    assert decoded.instance_variable_get(:@demo)
  end
end
