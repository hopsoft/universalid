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

  def self.possible_gid_string?(value)
    value = value.to_s
    GID_REGEX.match?(value) || GID_PARAM_REGEX.match?(value)
  end

  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new("0.1", "UniversalID")
  end
end

require_relative "universal_id/version"
require_relative "universal_id/errors"
require_relative "universal_id/config"
require_relative "universal_id/message_pack"
require_relative "universal_id/marshal"
require_relative "universal_id/packable"
require_relative "universal_id/packable_hash"
require_relative "universal_id/active_model_serializer"
