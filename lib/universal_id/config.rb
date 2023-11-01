# frozen_string_literal: true

module UniversalID
  class Config
    extend Forwardable
    include Singleton
    include MonitorMixin

    attr_reader :logger, :encode

    def logger=(value)
      synchronize { @logger = value }
    end

    def encode=(value)
      synchronize { @encode = value }
    end

    private

    def initialize
      super # Ensures MonitorMixin is initialized
      @logger = defined?(Rails) ? Rails.logger : Logger.new(File::NULL)
      @encode = {
        active_record: {keep_changes: false}
      }
    end
  end

  def self.config
    UniversalID::Config.instance
  end
end
