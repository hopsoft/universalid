# frozen_string_literal: true

# stdlib
require "base64"
require "cgi"
require "config"
require "digest/md5"
require "forwardable"
require "monitor"
require "singleton"
require "uri"

# 3rd party gems
require "brotli"
require "msgpack"

# internal
require_relative "universal_id/refinements/kernel"
require_relative "universal_id/version"
require_relative "universal_id/encoder"
require_relative "universal_id/uri/uid"
require_relative "universal_id/message_pack_factory"
require_relative "universal_id/active_record_encoder"

module UniversalID
  extend MonitorMixin

  class << self
    attr_writer :logger

    def logger
      @logger = defined?(Rails) ? Rails.logger : Logger.new(File::NULL)
    end

    def config
      synchronize do
        @config ||= Config.load_files(File.expand_path("../universal_id/message_pack/config.yml", __FILE__))
      end
    end

    # Yields a deep copy of the current config
    # Use with UniversalID::Encoder#Encode and MessagePack#pack
    # when you want to change how an object is encoded or packed
    def with_config
      synchronize do
        orig_config = config
        temp_config = Marshal.load(Marshal.dump(config))
        yield temp_config
      ensure
        @config = orig_config
      end
    end
  end
end
