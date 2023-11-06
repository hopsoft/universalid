# frozen_string_literal: true

require "config"

module UniversalID::Settings
  PATHS = {
    default: File.expand_path("../../../config/default.yml", __FILE__),
    squish: File.expand_path("../../../config/squish.yml", __FILE__),
    changes: File.expand_path("../../../config/changes.yml", __FILE__)
  }.freeze

  class << self
    def all
      {
        default: default,
        squish: squish
      }
    end

    # Returns the default configuration (config/default.yml)
    def default
      @config ||= Config.load_files(PATHS[:default])
    end

    # Returns the squish configuration (config/squish.yml)
    # Ensures all blank values are removed on UniversalID::Prepacker#prepack
    def squish
      @squish ||= Config.load_files(PATHS[:default], PATHS[:squish])
    end

    # Returns the changes configuration (config/changes.yml)
    # Presverves ActiveRecord changes on UniversalID::Prepacker#prepack
    def changes
      @changes ||= Config.load_files(PATHS[:default], PATHS[:changes])
    end

    def copy(settings)
      return Config::Options.new(settings) if settings.is_a?(Hash)
      settings = all[settings] if settings.is_a?(Symbol)
      return Config::Options.new if settings.nil?
      Marshal.load Marshal.dump(settings)
    end
  end
end
