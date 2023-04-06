# frozen_string_literal: true

module UniversalID::Portable
  extend ActiveSupport::Concern
  include GlobalID::Identification

  class_methods do
    def config
      UniversalID.config
    end

    def parse_gid(gid, options = {})
      GlobalID.parse(gid, options) || SignedGlobalID.parse(gid, options)
    end

    def find(id)
      raise NotImplementedError
    end
  end

  def id
    raise NotImplementedError
  end
end
