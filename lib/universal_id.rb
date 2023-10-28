# frozen_string_literal: true

require "active_model"
require "active_support/all"
require "base64"
require "cgi"
require "digest/md5"
require "globalid"
require "global_id/uri/gid"
require "uri"
require "zlib"

require_relative "universal_id/version"
require_relative "universal_id/config"
require_relative "universal_id/extensions"
require_relative "universal_id/message_pack"
require_relative "universal_id/marshal"
require_relative "universal_id/packable"
require_relative "universal_id/packable_hash"
require_relative "universal_id/uri"
require_relative "universal_id/active_model_serializer"

module UniversalID
  class << self
    def app=(name)
      @app = CGI.escape(name.to_s)
    end

    def app
      @app ||= GlobalID.app || CGI.escape(UniversalID.config.app)
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
