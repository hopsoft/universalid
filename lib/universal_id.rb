# frozen_string_literal: true

require "active_model"
require "active_support/all"
require "base64"
require "brotli"
require "cgi"
require "digest/md5"
require "globalid"
require "msgpack"
require "uri"
require "zlib"

require_relative "universal_id/version"
require_relative "universal_id/config"
require_relative "universal_id/refinements"
require_relative "universal_id/message_pack_types"
require_relative "universal_id/encoder"
require_relative "universal_id/uri/uid"
require_relative "universal_id/active_record_encoder"

if URI.respond_to? :register_scheme
  URI.register_scheme "UID", UniversalID::URI::UID unless URI.scheme_list.include?("UID")
else
  # shenanigans to support Ruby 3.0.X
  URI::UID = UniversalID::URI::UID
  URI.scheme_list["UID"] = URI::UID
end

module UniversalID
  using UniversalID::Refinements::String

  class << self
    def app=(name)
      @app = name.to_s.hostify
    end

    def app
      @app ||= GlobalID.app || UniversalID.config.app
    end

    # Sets the logger
    #
    # @param logger [Logger] a logger instance
    attr_writer :logger

    # Returns the logger instance (defaults to UniversalID.config.logger)
    #
    # @return [Logger]
    def logger
      @logger ||= UniversalID.config.logger
    end

    # Returns an instance of ActiveSupport::Deprecation
    # @return [ActiveSupport::Deprecation]
    def deprecator
      @deprecator ||= ActiveSupport::Deprecation.new("0.1", "UniversalID")
    end
  end
end
