# frozen_string_literal: true

# stdlib
require "base64"
require "cgi"
require "config"
require "digest/md5"
require "forwardable"
require "uri"

# 3rd party gems
require "brotli"
require "msgpack"

# internal
require_relative "universal_id/version"
require_relative "universal_id/config"
require_relative "universal_id/encoder"
require_relative "uri/uid"
require_relative "universal_id/prepacker"
require_relative "universal_id/message_pack_factory"
require_relative "universal_id/active_record_encoder"

module UniversalID
  class << self
    attr_writer :logger

    def logger
      @logger ||= defined?(Rails) ? Rails.logger : Logger.new(File::NULL)
    end
  end
end
