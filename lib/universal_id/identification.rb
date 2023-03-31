# frozen_string_literal: true

class UniversalID
  module Identification
    extend ActiveSupport::Concern

    # TODO: consider making this a Rails engine and adding support for
    #       Rails.application.config.universalid.secret
    SECRET = ENV.fetch("SECRET_KEY_BASE", ENV.fetch("UNIVERSALID_SECRET", "8kTADoLseDfFuUV3"))
    DEFAULT_OPTIONS = {app: "uid", verifier: GlobalID::Verifier.new(SECRET)}.freeze

    class_methods do
      def new_from_universal_id(uid, options = {})
        new GlobalID.parse(uid, DEFAULT_OPTIONS.merge(options)).find.attributes
      end
      alias_method :new_from_uid, :new_from_universal_id

      def new_from_signed_universal_id(suid, options = {})
        new SignedGlobalID.parse(suid, DEFAULT_OPTIONS.merge(options)).find.attributes
      end
      alias_method :new_from_suid, :new_from_signed_universal_id
    end

    def to_universal_id(options = {})
      GlobalID.create UniversalID.new(attributes), DEFAULT_OPTIONS.merge(options)
    end
    alias_method :to_uid, :to_universal_id

    def to_uid_param(options = {})
      to_universal_id(options).to_param
    end

    def to_signed_universal_id(options = {})
      SignedGlobalID.create UniversalID.new(attributes), DEFAULT_OPTIONS.merge(options)
    end
    alias_method :to_suid, :to_signed_universal_id

    def to_suid_param(options = {})
      to_signed_global_id(options).to_param
    end
  end
end
