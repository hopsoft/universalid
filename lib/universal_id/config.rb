# frozen_string_literal: true

module UniversalID
  def self.config
    @config ||= ActiveSupport::OrderedOptions.new.tap do |c|
      # Default options for UniversalID::PackableHash ........................................................
      c.packable_hash = {
        allow_blank: false,
        only: [], # keys to include (trumps except)
        except: [] # keys to exclude
      }
    end
  end
end
