# frozen_string_literal: true

module UniversalID
  DEFAULT_CONFIG_PATH = File.expand_path("../../../config/default.yml", __FILE__)
  COMPACT_CONFIG_PATH = File.expand_path("../../../config/compact.yml", __FILE__)

  class << self
    # Returns the default configuration (config/default.yml)
    def config
      @config ||= Config.load_files(DEFAULT_CONFIG_PATH)
    end

    # Returns the compact configuration (config/compact.yml)
    # This config can be used to ensure all blank values are removed on UniversalID::Prepacker#prepack
    def compact_config
      @compact_config ||= Config.load_files(DEFAULT_CONFIG_PATH, COMPACT_CONFIG_PATH)
    end
  end
end
