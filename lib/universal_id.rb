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
require_relative "universal_id/extensions/kernel_refinements"
require_relative "universal_id/extensions/string_refinements"
require_relative "universal_id/message_pack"
require_relative "universal_id/encoder"
require_relative "universal_id/uri/uid"
require_relative "universal_id/active_model_serializer"

URI.register_scheme "UID", UniversalID::URI::UID unless URI.scheme_list.include?("UID")

module UniversalID
  using UniversalID::Extensions::StringRefinements

  class << self
    def app=(name)
      @app = name.to_s.componentize
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
      @logger ||= config.logger
    end

    # Returns an instance of ActiveSupport::Deprecation
    # @return [ActiveSupport::Deprecation]
    def deprecator
      @deprecator ||= ActiveSupport::Deprecation.new("0.1", "UniversalID")
    end
  end
end
