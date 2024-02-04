# frozen_string_literal: true

class UniversalID::Packer::GlobalIDModelTest < Minitest::Test
  def test_new_from_uid
    uid = URI::UID.build(scalars)
    model = UniversalID::Extensions::GlobalIDModel.new(uid)

    assert_instance_of UniversalID::Extensions::GlobalIDModel, model
    assert_equal uid, model.uid
    assert_equal scalars, model.uid.decode
  end

  def test_new_from_uid_payload
    uid = URI::UID.build(scalars)
    model = UniversalID::Extensions::GlobalIDModel.new(uid.payload)

    assert_instance_of UniversalID::Extensions::GlobalIDModel, model
    assert_equal uid, model.uid
    assert_equal scalars, model.uid.decode
  end

  def test_new_from_uri
    uri = URI::UID.build(scalars).to_s
    model = UniversalID::Extensions::GlobalIDModel.new(uri)

    assert_instance_of UniversalID::Extensions::GlobalIDModel, model
    assert_equal uri, model.uid.to_s
    assert_equal scalars, model.uid.decode
  end
end
