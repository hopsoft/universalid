# frozen_string_literal: true

module UniversalID
  def self.config
    @config ||= ActiveSupport::OrderedOptions.new.tap do |c|
      # Default application name
      c.app = GlobalID.app || "UniversalID"

      # Default logger
      c.logger = defined?(Rails) ? Rails.logger : Logger.new(File::NULL)

      # Default encode options
      c.encode = {
        active_record: {
          # Whether or not to preserve unsaved changes when encoding/decoding
          # NOTE: Applies to all ActiveRecord models contained within the object being encoded
          #       Default can be overridden when calling `UniversalID::Encoder.encode`
          keep_changes: false
        }
      }
    end
  end
end
