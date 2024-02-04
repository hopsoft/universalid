# frozen_string_literal: true

class UniversalID::Packer::ActiveRecordRelationTest < Minitest::Test
  def test_pack_unpack
    Campaign.forge! 5, emails: 3, subject: "Flash Sale 123"
    expected = Campaign.email_subjects_like("Sale")
    expected.load
    expected.map { |c| c.emails.load }

    assert_equal 5, Campaign.count
    assert_equal 15, Email.count
    assert expected.loaded?
    assert expected.map { |c| c.emails.loaded? }.any?

    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    refute actual.loaded?
    refute actual.map { |c| c.emails.loaded? }.any?
    assert_equal expected, actual
    assert_equal expected.to_a, actual.to_a
  end
end

class UniversalID::Encoder::ActiveRecordRelationTest < Minitest::Test
  def test_encode_decode
    Campaign.forge! 5, emails: 3, subject: "Flash Sale 123"
    expected = Campaign.email_subjects_like("Sale")
    expected.load
    expected.map { |c| c.emails.load }

    assert_equal 5, Campaign.count
    assert_equal 15, Email.count
    assert expected.loaded?
    assert expected.map { |c| c.emails.loaded? }.any?

    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    refute actual.loaded?
    refute actual.map { |c| c.emails.loaded? }.any?
    assert_equal expected, actual
    assert_equal expected.to_a, actual.to_a
  end
end

class URI::UID::ActiveRecordRelationTest < Minitest::Test
  def test_build_parse_decode
    Campaign.forge! 5, emails: 3, subject: "Flash Sale 123"
    expected = Campaign.email_subjects_like("Sale")
    expected.load
    expected.map { |c| c.emails.load }

    assert_equal 5, Campaign.count
    assert_equal 15, Email.count
    assert expected.loaded?
    assert expected.map { |c| c.emails.loaded? }.any?

    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    refute actual.loaded?
    refute actual.map { |c| c.emails.loaded? }.any?
    assert_equal expected, actual
    assert_equal expected.to_a, actual.to_a
  end

  def test_global_id
    Campaign.forge! 5, emails: 3, subject: "Flash Sale 123"
    expected = Campaign.email_subjects_like("Sale")
    expected.load
    expected.map { |c| c.emails.load }

    assert_equal 5, Campaign.count
    assert_equal 15, Email.count
    assert expected.loaded?
    assert expected.map { |c| c.emails.loaded? }.any?

    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    refute actual.loaded?
    refute actual.map { |c| c.emails.loaded? }.any?
    assert_equal expected, actual
    assert_equal expected.to_a, actual.to_a
  end

  def test_signed_global_id
    Campaign.forge! 5, emails: 3, subject: "Flash Sale 123"
    expected = Campaign.email_subjects_like("Sale")
    expected.load
    expected.map { |c| c.emails.load }

    assert_equal 5, Campaign.count
    assert_equal 15, Email.count
    assert expected.loaded?
    assert expected.map { |c| c.emails.loaded? }.any?

    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    refute actual.loaded?
    refute actual.map { |c| c.emails.loaded? }.any?
    assert_equal expected, actual
    assert_equal expected.to_a, actual.to_a
  end
end
