# frozen_string_literal: true

if defined?(GlobalID::Identification) && defined?(SignedGlobalID)

  require "forwardable"
  require_relative "global_id_model"

  module UniversalID::Extensions::GlobalIDUIDExtension
    extend Forwardable

    def self.included(mixer)
      mixer.extend ClassMethods
    end

    # Adds all GlobalID::Identification methods
    def_delegators(:to_global_id_model, *GlobalID::Identification.instance_methods(false))

    # Returns a UniversalID::Extensions::GlobalIDModel instance
    # which implements the GlobalID::Identification interface/protocol
    def to_global_id_model
      UniversalID::Extensions::GlobalIDModel.new self
    end

    module ClassMethods
      def from_global_id_record(gid_record)
        gid_record&.find&.uid
      end

      def from_global_id(gid, options = {})
        from_global_id_record GlobalID.parse(gid, options)
      end

      alias_method :from_gid, :from_global_id

      def from_signed_global_id(sgid, options = {})
        from_global_id_record SignedGlobalID.parse(sgid, options)
      end

      alias_method :from_sgid, :from_signed_global_id
    end
  end

end
