# frozen_string_literal: true

module UniversalID::MessagePackTypes
  class ActiveRecordRelationTest < Minitest::Test
    def test_global_id
      relation = Campaign.joins(:emails).where("emails.subject LIKE ?", "Flash Sale%")
      relation.load

      packed = UniversalID::MessagePackFactory.pack(relation)
      unpacked = UniversalID::MessagePackFactory.unpack(packed)

      assert relation.loaded?
      refute unpacked.loaded?
      assert_equal relation, unpacked
      assert_equal relation.to_a, unpacked.to_a
    end
  end
end
