# frozen_string_literal: true

module UniversalID
  def self.config
    @config ||= ActiveSupport::OrderedOptions.new.tap do |c|
      # Default application name
      c.app = "UniversalID"

      # Default logger
      c.logger = Rails.logger if defined?(Rails)

      # Default options for UniversalID::PackableHash#pack
      c.packable_hash = {
        pack_options: {
          allow_blank: false,
          only: [], # keys to include (trumps except)
          except: [] # keys to exclude
        }
      }
    end
  end
end
