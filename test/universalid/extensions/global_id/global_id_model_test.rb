# frozen_string_literal: true

class UniversalID::Packer::GlobalIDModelTest < Minitest::Test
  def test_new_from_uid
    object = {a: 1, b: 2, c: 3}
    uid = URI::UID.build(object)
    model = UniversalID::Extensions::GlobalIDModel.new(uid)

    assert_instance_of UniversalID::Extensions::GlobalIDModel, model
    assert_equal uid, model.uid
    assert_equal object, model.uid.decode
  end

  def test_new_from_uid_payload
    object = {a: 1, b: 2, c: 3}
    uid = URI::UID.build(object)
    model = UniversalID::Extensions::GlobalIDModel.new(uid.payload)

    assert_instance_of UniversalID::Extensions::GlobalIDModel, model
    assert_equal uid, model.uid
    assert_equal object, model.uid.decode
  end

  def test_new_from_uri
    object = {a: 1, b: 2, c: 3}
    uri = URI::UID.build(object).to_s
    model = UniversalID::Extensions::GlobalIDModel.new(uri)

    assert_instance_of UniversalID::Extensions::GlobalIDModel, model
    assert_equal uri, model.uid.to_s
    assert_equal object, model.uid.decode
  end
end
