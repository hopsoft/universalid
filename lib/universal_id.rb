# frozen_string_literal: true

require "date"
require "forwardable"
require "ostruct"
require "uri"

require_relative "universal_id/version"
require_relative "universal_id/settings"
require_relative "universal_id/encoder"
require_relative "uri/uid"
require_relative "universal_id/prepacker"
require_relative "universal_id/prepack_options"
require_relative "universal_id/message_pack_factory"

UniversalID::Settings.instance # initialize settings

module UniversalID
  class << self
    attr_writer :logger

    def logger
      @logger ||= defined?(Rails) ? Rails.logger : Logger.new(File::NULL)
    end
  end
end
