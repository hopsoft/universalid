# frozen_string_literal: true

require "date"
require "forwardable"
require "ostruct"
require "uri"

module UniversalID
  module Contrib; end

  class << self
    attr_writer :logger

    def logger
      @logger ||= defined?(Rails) ? Rails.logger : Logger.new(File::NULL)
    end
  end
end

require_relative "universal_id/version"
require_relative "universal_id/refinements"
require_relative "universal_id/settings"
require_relative "universal_id/encoder"
require_relative "uri/uid"
require_relative "universal_id/prepacker"
require_relative "universal_id/prepack_options"
require_relative "universal_id/message_pack_factory"

UniversalID::Settings.instance # initialize settings
