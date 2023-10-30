# frozen_string_literal: true

require_relative "../test_helper"

# class UniversalID::PackableHash
#   class GIDTest < ActiveSupport::TestCase
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
#       @packable = UniversalID::PackableHash.new(@hash)
#       @options = {except: %w[created_at updated_at remove]}
#     end
#
#     def test_to_global_id_object
#       gid_object = @packable.to_global_id_object
#       assert gid_object.is_a?(UniversalID::Packable::GlobalIDObject)
#     end
#
#     def test_unpack_global_id
#       gid = @packable.to_global_id_object(@options).to_gid
#       assert_equal @expected, UniversalID::PackableHash.unpack(gid)
#     end
#
#     def test_unpack_global_id_string
#       gid = @packable.to_global_id_object(@options).to_gid.to_s
#       assert_equal @expected, UniversalID::PackableHash.unpack(gid)
#     end
#
#     def test_unpack_global_id_param
#       gid = @packable.to_global_id_object(@options).to_gid_param
#       assert_equal @expected, UniversalID::PackableHash.unpack(gid)
#     end
#   end
# end
