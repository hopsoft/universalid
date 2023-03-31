# frozen_string_literal: true

module UniversalID
  module Identification
    extend ActiveSupport::Concern

    # TODO: consider making this a Rails engine and adding support for
    #       Rails.application.config.universalid.secret
    SECRET = ENV.fetch("SECRET_KEY_BASE", ENV.fetch("UNIVERSALID_SECRET", "8kTADoLseDfFuUV3"))
    DEFAULT_OPTIONS = {app: "attributes.universalid", verifier: GlobalID::Verifier.new(SECRET)}.freeze

    class_methods do
      def new_from_attributes_global_id(attributes_gid, options = {})
        new GlobalID.parse(attributes_gid, DEFAULT_OPTIONS.merge(options)).find
      end
      alias_method :new_from_attributes_gid, :new_from_attributes_global_id

      def new_from_attributes_signed_global_id(attributes_sgid, options = {})
        new SignedGlobalID.parse(attributes_sgid, DEFAULT_OPTIONS.merge(options)).find
      end
      alias_method :new_from_attributes_suid, :new_from_attributes_signed_global_id
    end

    def universal_attributes
      UniversalID::Attributes.new attributes
    end

    def to_attributes_global_id(options = {})
      GlobalID.create universal_attributes, DEFAULT_OPTIONS.merge(options)
    end
    alias_method :to_attributes_gid, :to_attributes_global_id

    def to_attributes_global_id_param(options = {})
      to_attributes_gid(options).to_param
    end
    alias_method :to_attributes_gid_param, :to_attributes_global_id_param

    def to_attributes_signed_global_id(options = {})
      SignedGlobalID.create universal_attributes, DEFAULT_OPTIONS.merge(options)
    end
    alias_method :to_attributes_sgid, :to_attributes_signed_global_id

    def to_attributes_signed_global_id_param(options = {})
      to_attributes_sgid(options).to_param
    end
    alias_method :to_attributes_sgid_param, :to_attributes_signed_global_id_param
  end
end
