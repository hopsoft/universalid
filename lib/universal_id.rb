# frozen_string_literal: true

require "base64"
require "zlib"
require "globalid"
require "active_model"
require "active_support/all"

module UniversalID
  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new("0.1", "UniversalID")
  end
end

require_relative "universal_id/version"
require_relative "universal_id/errors"
require_relative "universal_id/config"
require_relative "universal_id/portable"
require_relative "universal_id/portable_hash"
require_relative "universal_id/active_model_serializer"
