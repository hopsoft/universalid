# frozen_string_literal: true

require "active_model"
require "active_support/all"
require "base64"
require "digest/md5"
require "globalid"
require "msgpack"
require "zlib"

module UniversalID
  GID_REGEX = /\Agid:\/\/.+\z/
  GID_PARAM_REGEX = /\A[0-9a-zA-Z_+-\/]{20,}={0,2}.*\z/

  # Checks if a given value could possibly be a GlobalID string.
  #
  # @param value [Object] The value to be checked.
  # @return [Boolean]
  #
  # @example
  #   UniversalID.possible_gid_string?('gid://shopify/Product/1234567890') #=> true
  def self.possible_gid_string?(value)
    value = value.to_s
    GID_REGEX.match?(value) || GID_PARAM_REGEX.match?(value)
  end

  # Returns an instance of ActiveSupport::Deprecation
  # @return [ActiveSupport::Deprecation]
  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new("0.1", "UniversalID")
  end
end

require_relative "universal_id/version"
require_relative "universal_id/errors"
require_relative "universal_id/config"
require_relative "universal_id/message_pack"
require_relative "universal_id/marshal"
require_relative "universal_id/packable_object"
require_relative "universal_id/packable"
require_relative "universal_id/marshalable_hash"
require_relative "universal_id/active_model_serializer"
