# frozen_string_literal: true

module UniversalID
  DEFAULT_CONFIG_PATH = File.expand_path("../../../config/default.yml", __FILE__)
  COMPACT_CONFIG_PATH = File.expand_path("../../../config/compact.yml", __FILE__)

  class << self
    # Returns the current configuration
    def config
      @config ||= Config.load_files(DEFAULT_CONFIG_PATH)
    end

    # Returns the compact configuration `include_blank=false`
    # i.e. blanks values are removed for smaller MessagePack payload size
    def compact_config
      @compact_config ||= Config.load_files(DEFAULT_CONFIG_PATH, COMPACT_CONFIG_PATH)
    end
  end
end
