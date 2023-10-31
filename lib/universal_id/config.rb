# frozen_string_literal: true

module UniversalID
  def self.config
    @config ||= ActiveSupport::OrderedOptions.new.tap do |c|
      # Default application name
      c.app = GlobalID.app || "UniversalID"

      # Default logger
      c.logger = Rails.logger if defined?(Rails)
    end
  end
end
