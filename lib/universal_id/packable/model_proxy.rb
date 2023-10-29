# frozen_string_literal: true

require_relative "../uri/uid"

module UniversalID::Packable
  class ModelProxy
    include GlobalID::Identification

    class << self
      def find(id)
        UniversalID::URI::UID.parse id
      end
    end

    attr_reader :id

    def initialize(uid)
      @id = uid.to_s
    end
  end
end
