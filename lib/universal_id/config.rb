# frozen_string_literal: true

module UniversalID
  class Config
    include Singleton

    attr_accessor :logger, :message_packer

    private

    def initialize
      @logger = defined?(Rails) ? Rails.logger : Logger.new(File::NULL)

      # Default configuration applied by UniversalID::MessagePackFactory when packing objects with msgpack
      # ------------------------------------------------------------------------------------------------------
      # For an example of how these defaults are applied,
      # SEE: lib/universal_id/message_pack_types/rails/global_id/identification_packer.rb
      # ------------------------------------------------------------------------------------------------------
      # NOTE: The data structure should match the directory structure at: lib/universal_id/message_pack_types
      # ------------------------------------------------------------------------------------------------------
      self.message_packer = {
        global_id: {
          identification: {
            # Whether or not to keep nil values when packing
            compact: false,

            # the method to use for pre-packing the record (i.e. trasforming from Object → Hash)
            #
            # * :attributes (default)
            # * :as_json
            # * :serializable_hash
            # * :my_custom_method
            # * :etc.
            #
            prepack_method_name: :attributes,

            # List of keys/attributes to exclude when packing
            # NOTE: Accepts Regexp, Symbol, and String values
            filters: [
              /credit_card/i,
              /cvv/i,
              /password/i,
              /private_key/i,
              /social_security/i,
              /ssn/i
            ],

            active_record: {
              # Indicates if we should preserve unsaved ActiveRecord changes when packing
              # NOTE: Only applied when: prepack_method_name == :attributes
              #       New record changes are always preserved regardless of this setting
              keep_changes: false
            }
          }
        }
      }
    end
  end

  def self.config
    UniversalID::Config.instance
  end
end
