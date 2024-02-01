# frozen_string_literal: true

class UniversalID::Packer::ActiveRecordRelationTest < Minitest::Test
  def test_pack_unpack
    Campaign.forge! 5, emails: 3, subject: "Flash Sale 123"
    value = Campaign.email_subjects_like("Sale")
    value.load
    value.map { |c| c.emails.load }

    assert_equal 5, Campaign.count
    assert_equal 15, Email.count
    assert value.loaded?
    assert value.map { |c| c.emails.loaded? }.any?

    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    refute unpacked.loaded?
    refute unpacked.map { |c| c.emails.loaded? }.any?
    assert_equal value, unpacked
    assert_equal value.to_a, unpacked.to_a
  end
end

class UniversalID::Encoder::ActiveRecordRelationTest < Minitest::Test
  def test_encode_decode
    Campaign.forge! 5, emails: 3, subject: "Flash Sale 123"
    value = Campaign.email_subjects_like("Sale")
    value.load
    value.map { |c| c.emails.load }

    assert_equal 5, Campaign.count
    assert_equal 15, Email.count
    assert value.loaded?
    assert value.map { |c| c.emails.loaded? }.any?

    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    refute decoded.loaded?
    refute decoded.map { |c| c.emails.loaded? }.any?
    assert_equal value, decoded
    assert_equal value.to_a, decoded.to_a
  end
end

class URI::UID::ActiveRecordRelationTest < Minitest::Test
  def test_build_parse_decode
    Campaign.forge! 5, emails: 3, subject: "Flash Sale 123"
    value = Campaign.email_subjects_like("Sale")
    value.load
    value.map { |c| c.emails.load }

    assert_equal 5, Campaign.count
    assert_equal 15, Email.count
    assert value.loaded?
    assert value.map { |c| c.emails.loaded? }.any?

    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    refute decoded.loaded?
    refute decoded.map { |c| c.emails.loaded? }.any?
    assert_equal value, decoded
    assert_equal value.to_a, decoded.to_a
  end

  def test_global_id
    Campaign.forge! 5, emails: 3, subject: "Flash Sale 123"
    value = Campaign.email_subjects_like("Sale")
    value.load
    value.map { |c| c.emails.load }

    assert_equal 5, Campaign.count
    assert_equal 15, Email.count
    assert value.loaded?
    assert value.map { |c| c.emails.loaded? }.any?

    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    refute decoded.loaded?
    refute decoded.map { |c| c.emails.loaded? }.any?
    assert_equal value, decoded
    assert_equal value.to_a, decoded.to_a
  end

  def test_signed_global_id
    Campaign.forge! 5, emails: 3, subject: "Flash Sale 123"
    value = Campaign.email_subjects_like("Sale")
    value.load
    value.map { |c| c.emails.load }

    assert_equal 5, Campaign.count
    assert_equal 15, Email.count
    assert value.loaded?
    assert value.map { |c| c.emails.loaded? }.any?

    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    refute decoded.loaded?
    refute decoded.map { |c| c.emails.loaded? }.any?
    assert_equal value, decoded
    assert_equal value.to_a, decoded.to_a
  end
end
