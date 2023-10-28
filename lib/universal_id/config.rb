# frozen_string_literal: true

module UniversalID
  def self.config
    @config ||= ActiveSupport::OrderedOptions.new.tap do |c|
      c.marshalable_hash = {
        to_packable_options: {
          allow_blank: false,
          only: [], # keys to include (trumps except)
          except: [] # keys to exclude
        }
      }
    end
  end
end
