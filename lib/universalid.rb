# frozen_string_literal: true

require "zeitwerk"

module UniversalID
  module Contrib; end

  class << self
    attr_writer :logger

    def logger
      @logger ||= defined?(Rails) ? Rails.logger : Logger.new(File::NULL)
    end
  end
end

Zeitwerk::Loader.for_gem(warn_on_extra_files: false).tap do |loader|
  loader.inflector = Zeitwerk::GemInflector.new(__dir__)
  loader.ignore "#{__dir__}/universalid/**/*message_pack_type*"
  loader.ignore "#{__dir__}/universalid/contrib"
  loader.inflector.inflect("universalid" => "UniversalID")
  loader.inflector.inflect("uri" => "URI")
  loader.inflector.inflect("uid" => "UID")
  loader.inflector.inflect("version" => "VERSION")
  loader.setup
  loader.eager_load
end

UniversalID::Settings.instance # initialize settings
