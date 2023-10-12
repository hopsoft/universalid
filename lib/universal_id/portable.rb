# frozen_string_literal: true

module UniversalID::Portable
  extend ActiveSupport::Concern
  include GlobalID::Identification

  GID_REGEX = /\Agid:\/\/.*\z/
  GID_PARAM_REGEX = /\A[0-9a-zA-Z+\/]{20,}={0,2}.*\z/

  class_methods do
    def config
      UniversalID.config
    end

    def parse_gid(gid, options = {})
      return gid if gid.is_a?(GlobalID)
      return nil unless possible_gid_string?(gid)
      GlobalID.parse(gid, options) || SignedGlobalID.parse(gid, options)
    end

    def find(id)
      raise NotImplementedError
    end

    def possible_gid_string?(value)
      return false unless value.is_a?(String)
      GID_REGEX.match?(value) || GID_PARAM_REGEX.match?(value)
    end
  end

  def id
    raise NotImplementedError
  end
end
