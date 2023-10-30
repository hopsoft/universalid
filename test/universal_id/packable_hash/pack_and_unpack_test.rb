# frozen_string_literal: true

require_relative "../test_helper"

# class UniversalID::PackableHash
#   class PackAndUnpackTest < ActiveSupport::TestCase
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
#       @expected_hash = {
#         "test" => true,
#         "example" => "value",
#         "nested" => {"keep" => "keep"}
#       }
#       @expected_uid_string = "eNprXlKSWlxyeHlqRWJuQU7q0rLEnNLUZXlAsdSUxiXZqakFYAIAdhkSPAx"
#       @packable = UniversalID::PackableHash.new(@hash)
#       @options = {except: %w[created_at updated_at remove]}
#     end
#
#     def test_pack
#       actual = @packable.pack(@options)
#       assert_equal @expected_uid_string, actual
#     end
#
#     def test_unpack
#       hash = UniversalID::PackableHash.unpack(@expected_uid_string)
#       assert_equal @expected_hash, hash
#     end
#   end
# end
