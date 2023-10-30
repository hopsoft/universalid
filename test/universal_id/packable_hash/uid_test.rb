# frozen_string_literal: true

require_relative "../test_helper"

# class UniversalID::PackableHash
#   class UIDTest < ActiveSupport::TestCase
#     def setup
#       @hash = {
#         test: true,
#         example: "value",
#         other: nil,
#         created_at: Time.current,
#         updated_at: Time.current,
#         nested: {
#           keep: "keep",
#           remove: "remove"
#         }
#       }
#       @expected_uid_string = "uid://universal_id/eNprXlKSWlxyeHlqRWJuQU7q0rLEnNLUZXlAsdSUxiXZqakFYAIAdhkSPA"
#       @expected_hash = {
#         "test" => true,
#         "example" => "value",
#         "nested" => {"keep" => "keep"}
#       }
#       @packable = UniversalID::PackableHash.new(@hash)
#       @options = {except: %w[created_at updated_at remove]}
#     end
#
#     def test_to_uid
#       actual = @packable.to_uid(@options)
#       assert actual.is_a?(URI)
#       assert actual.is_a?(UniversalID::URI::UID)
#       assert_equal @expected_uid_string, actual.to_s
#     end
#
#     def test_unpack_uid
#       uid = UniversalID::URI::UID.parse(@expected_uid_string)
#       actual = UniversalID::PackableHash.unpack(uid)
#       assert_equal @expected_hash, actual
#     end
#
#     def test_unpack_uid_string
#       actual = UniversalID::PackableHash.unpack(@expected_uid_string)
#       assert_equal @expected_hash, actual
#     end
#   end
# end
