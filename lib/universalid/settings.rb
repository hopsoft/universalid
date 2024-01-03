# frozen_string_literal: true

require "monitor"
require "singleton"
require "config"

class UniversalID::Settings
  include MonitorMixin
  include Singleton

  DEFAULT_FILE_PATH = File.expand_path("../../config/default.yml", __dir__)

  class << self
    def build(**options)
      instance.default_copy.tap do |settings|
        options.each { |key, val| assign key, val, to: settings }
      end
    end

    def register(...)
      instance.register(...)
    end

    def [](key)
      instance[key]
    end

    private

    def assign(key, value, to:)
      return if value.nil?

      case {key.to_sym => value}
      in prepack: prepack then prepack.each { |k, v| assign k, v, to: to }
      in exclude: exclude then to.prepack.exclude = exclude
      in include: inc then to.prepack.include = inc
      in include_blank: include_blank then to.prepack.include_blank = !!include_blank
      in database: database then database.each { |k, v| assign k, v, to: to }
      in include_keys: include_keys then to.prepack.database.include_keys = !!include_keys
      in include_timestamps: include_timestamps then to.prepack.database.include_timestamps = !!include_timestamps
      in include_unsaved_changes: include_unsaved_changes then to.prepack.database.include_unsaved_changes = !!include_unsaved_changes
      in include_descendants: include_descendants then to.prepack.database.include_descendants = !!include_descendants
      in descendant_depth: descendant_depth then to.prepack.database.descendant_depth = descendant_depth
      else # ignore key
      end
    end
  end

  def register(key, options = {})
    key = key.to_s.strip.downcase.to_sym
    synchronize do
      raise ArgumentError, "Already registered! key: #{key}" if registry.key? key
      config = case options
      when String then Config.load_files(options)
      when Hash then Config::Options.new(options)
      when Config::Options then options
      else raise ArgumentError, "Invalid options! Must be a String, Hash, or Config::Options."
      end

      config = self.class.build(**config) unless key == :default
      registry[key] = config
      self.class.define_method(key) { config }
      self.class.define_method(:"#{key}_copy") { Marshal.load Marshal.dump(config) }
      self.class.define_singleton_method(key) { instance.public_send key }
      [key, config]
    end
  end

  def [](key)
    registry[key.to_sym]
  end

  private

  attr_reader :registry

  def initialize
    super
    @registry = {}
    register :default, DEFAULT_FILE_PATH
  end
end
