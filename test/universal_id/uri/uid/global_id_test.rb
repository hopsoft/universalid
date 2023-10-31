# frozen_string_literal: true

require_relative "../../test_helper"

class UniversalID::URI::UID::GlobalIDRecordTest < ActiveSupport::TestCase
  def test_to_global_id_record
    with_persisted_campaign do |campaign|
      hash = {number: 123, string: "data", array: [1, 2, 3], hash: {model: campaign}}
      uid = UniversalID::URI::UID.create(hash)
      gid_record = uid.to_global_id_record
      assert_equal gid_record.id, GlobalID.parse(gid_record.to_gid_param).find.id
    end
  end

  def test_to_global_id
    with_persisted_campaign do |campaign|
      hash = {number: 123, string: "data", array: [1, 2, 3], hash: {model: campaign}}
      uid = UniversalID::URI::UID.create(hash)
      gid = uid.to_gid
      assert_equal gid, GlobalID.parse(gid.to_param)
    end
  end

  def test_to_uid
    with_persisted_campaign do |campaign|
      hash = {number: 123, string: "data", array: [1, 2, 3], hash: {model: campaign}}
      uid = UniversalID::URI::UID.create(hash)
      gid = uid.to_gid
      assert_equal uid, GlobalID.parse(gid.to_param).find.uid
    end
  end

  def test_to_signed_global_id
    with_persisted_campaign do |campaign|
      hash = {number: 123, string: "data", array: [1, 2, 3], hash: {model: campaign}}
      uid = UniversalID::URI::UID.create(hash)
      sgid = uid.to_sgid
      assert_equal uid, SignedGlobalID.parse(sgid.to_param).find.uid
    end
  end
end
