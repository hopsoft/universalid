# frozen_string_literal: true

# TODO: Consider cleaning up the alias verbosity?
module UniversalID
  module Identification
    extend ActiveSupport::Concern

    def self.config
      UniversalID.config.identification
    end

    class_methods do
      def new_from_universal_attributes_global_id(ugid, options = {})
        new GlobalID.parse(ugid, UniversalID::Identification.config[:gid]).find
      rescue => error
        new.tap { |instance| instance.ugid_error = UniversalID::LocatorError.new(ugid, error) }
      end
      alias_method :new_from_universal_attributes_gid, :new_from_universal_attributes_global_id
      alias_method :new_from_ugid, :new_from_universal_attributes_gid

      def new_from_universal_attributes_signed_global_id(usgid, options = {})
        new SignedGlobalID.parse(usgid, UniversalID::Identification.config[:sgid]).find
      rescue => error
        new.tap { |instance| instance.usgid_error = UniversalID::LocatorError.new(usgid, error) }
      end
      alias_method :new_from_universal_attributes_sgid, :new_from_universal_attributes_signed_global_id
      alias_method :new_from_usgid, :new_from_universal_attributes_sgid
    end

    included do
      validate :validate_ugid
      validate :validate_usgid
    end

    attr_accessor :universal_attributes_global_id_error
    alias_method :universal_attributes_gid_error, :universal_attributes_global_id_error
    alias_method :universal_attributes_gid_error=, :universal_attributes_global_id_error=
    alias_method :ugid_error, :universal_attributes_gid_error
    alias_method :ugid_error=, :universal_attributes_gid_error=

    attr_accessor :universal_attributes_signed_global_id_error
    alias_method :universal_attributes_sgid_error, :universal_attributes_signed_global_id_error
    alias_method :universal_attributes_sgid_error=, :universal_attributes_signed_global_id_error=
    alias_method :usgid_error, :universal_attributes_sgid_error
    alias_method :usgid_error=, :universal_attributes_sgid_error=

    def validate_universal_attributes_global_id
      return unless ugid_error
      errors.add :base, "UniversalID GlobalID not found! #{ugid_error.message}"
    end
    alias_method :validate_universal_attributes_gid, :validate_universal_attributes_global_id
    alias_method :validate_ugid, :validate_universal_attributes_gid

    def validate_universal_attributes_signed_global_id
      return unless usgid_error
      errors.add :base, "UniversalID SignedGlobalID not found! #{usgid_error.message}"
    end
    alias_method :validate_universal_attributes_sgid, :validate_universal_attributes_signed_global_id
    alias_method :validate_usgid, :validate_universal_attributes_sgid

    def universal_attributes
      UniversalID::Attributes.new attributes
    end

    def to_universal_attributes_global_id(options = {})
      universal_attributes.to_gid UniversalID::Identification.config[:gid].merge(options)
    end
    alias_method :to_universal_attributes_gid, :to_universal_attributes_global_id
    alias_method :to_ugid, :to_universal_attributes_gid

    def to_universal_attributes_global_id_param(options = {})
      to_universal_attributes_gid(options).to_param
    end
    alias_method :to_universal_attributes_gid_param, :to_universal_attributes_global_id_param
    alias_method :to_ugid_param, :to_universal_attributes_gid_param

    def to_universal_attributes_signed_global_id(options = {})
      universal_attributes.to_sgid UniversalID::Identification.config[:sgid].merge(options)
    end
    alias_method :to_universal_attributes_sgid, :to_universal_attributes_signed_global_id
    alias_method :to_usgid, :to_universal_attributes_sgid

    def to_universal_attributes_signed_global_id_param(options = {})
      to_universal_attributes_sgid(options).to_param
    end
    alias_method :to_universal_attributes_sgid_param, :to_universal_attributes_signed_global_id_param
    alias_method :to_usgid_param, :to_universal_attributes_sgid_param
  end
end
