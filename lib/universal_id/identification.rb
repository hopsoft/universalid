# frozen_string_literal: true

module UniversalID
  module Identification
    extend ActiveSupport::Concern

    # TODO: consider making this a Rails engine and adding support for
    #       Rails.application.config.universalid.secret
    SECRET = ENV.fetch("SECRET_KEY_BASE", ENV.fetch("UNIVERSALID_SECRET", "8kTADoLseDfFuUV3"))
    DEFAULT_GID_OPTIONS = {
      app: "attributes.universalid",
      verifier: GlobalID::Verifier.new(SECRET)
    }.freeze
    DEFAULT_SGID_OPTIONS = DEFAULT_GID_OPTIONS.merge(expires_in: nil).freeze

    class_methods do
      def new_from_universal_attributes_global_id(ugid, options = {})
        new GlobalID.parse(ugid, ugid_options(options)).find
      end
      alias_method :new_from_universal_attributes_gid, :new_from_universal_attributes_global_id
      alias_method :new_from_ugid, :new_from_universal_attributes_global_id

      def new_from_universal_attributes_signed_global_id(usgid, options = {})
        new SignedGlobalID.parse(usgid, sugid_options(options)).find
      end
      alias_method :new_from_universal_attributes_sgid, :new_from_universal_attributes_signed_global_id
      alias_method :new_from_usgid, :new_from_universal_attributes_signed_global_id

      def universal_attributes_global_id_options(options = {})
        DEFAULT_GID_OPTIONS.merge options
      end
      alias_method :universal_attributes_gid_options, :universal_attributes_global_id_options
      alias_method :ugid_options, :universal_attributes_global_id_options

      def universal_attributes_signed_global_id_options(options = {})
        DEFAULT_SGID_OPTIONS.merge options
      end
      alias_method :universal_attributes_sgid_options, :universal_attributes_signed_global_id_options
      alias_method :sugid_options, :universal_attributes_signed_global_id_options
    end

    delegate :ugid_options, to: :"self.class"

    def universal_attributes
      UniversalID::Attributes.new attributes
    end

    def to_universal_attributes_global_id(options = {})
      universal_attributes.to_gid ugid_options(options)
    end
    alias_method :to_universal_attributes_gid, :to_universal_attributes_global_id
    alias_method :to_ugid, :to_universal_attributes_global_id

    def to_universal_attributes_global_id_param(options = {})
      to_universal_attributes_gid(ugid_options(options)).to_param
    end
    alias_method :to_universal_attributes_gid_param, :to_universal_attributes_global_id_param
    alias_method :to_ugid_param, :to_universal_attributes_global_id_param

    def to_universal_attributes_signed_global_id(options = {})
      universal_attributes.to_sgid ugid_options(options)
    end
    alias_method :to_universal_attributes_sgid, :to_universal_attributes_signed_global_id
    alias_method :to_usgid, :to_universal_attributes_signed_global_id

    def to_universal_attributes_signed_global_id_param(options = {})
      to_universal_attributes_sgid(ugid_options(options)).to_param
    end
    alias_method :to_universal_attributes_sgid_param, :to_universal_attributes_signed_global_id_param
    alias_method :to_usgid_param, :to_universal_attributes_signed_global_id_param
  end
end
