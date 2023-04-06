# frozen_string_literal: true

module UniversalID
  def self.config
    @config ||= begin
      options = ActiveSupport::OrderedOptions.new

      # Default options for UniversalID::PortableHash ........................................................
      options.portable_hash = {
        allow_blank: false,
        only: [], # keys to include (trumps except)
        except: [] # keys to exclude
      }

      options
    end
  end
end
