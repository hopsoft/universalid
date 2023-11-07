# frozen_string_literal: true

require "forwardable"
require "monitor"
require "singleton"
require "config"

class UniversalID::Settings
  include MonitorMixin
  include Singleton

  DEFAULT_FILE_PATH = File.expand_path("../../../config/default.yml", __FILE__)

  def register(key, config = {})
    key = key.to_s.strip.downcase.to_sym
    synchronize do
      raise ArgumentError, "Already registered! key: #{key}" if registry.key? key
      config = case config
      when String then Config.load_files(config)
      when Hash then Config::Options.new(config)
      when Config::Options then config
      else raise ArgumentError, "Invalid options! Must be a String, Hash, or Config::Options."
      end

      registry[key] = config
      self.class.define_method(key) { config }
      self.class.define_method("#{key}_copy") { Marshal.load Marshal.dump(config) }
      self.class.define_singleton_method(key) { instance.public_send key }
      self.class.define_singleton_method("#{key}_copy") { instance.public_send "#{key}_copy" }
    end
  end

  private

  attr_reader :registry

  def initialize
    super
    @registry = {}
    register :default, DEFAULT_FILE_PATH
  end
end
