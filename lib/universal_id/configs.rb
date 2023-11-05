# frozen_string_literal: true

require "config"

module UniversalID::Configs
  PATHS = {
    default: File.expand_path("../../../config/default.yml", __FILE__),
    squish: File.expand_path("../../../config/squish.yml", __FILE__)
  }.freeze

  class << self
    # Returns all preloaded configs
    def all
      PATHS.keys.map { |key| public_send key }
    end

    # Returns the default configuration (config/default.yml)
    def default
      @config ||= Config.load_files(PATHS[:default])
    end

    # Returns the squish configuration (config/squished.yml)
    # This config can be used to ensure all blank values are removed on UniversalID::Prepacker#prepack
    def squish
      @squish ||= Config.load_files(PATHS[:default], PATHS[:squish])
    end
  end
end
