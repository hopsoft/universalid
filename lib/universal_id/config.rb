# frozen_string_literal: true

module UniversalID
  extend MonitorMixin

  DEFAULT_CONFIG_PATH = File.expand_path("../../../config/default.yml", __FILE__)
  COMPACT_CONFIG_PATH = File.expand_path("../../../config/compact.yml", __FILE__)

  class << self
    def config
      @config ||= Config.load_files(DEFAULT_CONFIG_PATH)
    end

    def compact_config
      @default_config ||= Config.load_files(DEFAULT_CONFIG_PATH, COMPACT_CONFIG_PATH)
    end

    # Yields a deep copy of the current config
    # Use with UniversalID::Encoder#Encode and MessagePack#pack
    # when you want to change how an object is encoded or packed
    def with_config
      synchronize do
        orig_config = config
        temp_config = Marshal.load(Marshal.dump(config))
        yield temp_config if block_given?
      ensure
        @config = orig_config
      end
    end
  end
end
