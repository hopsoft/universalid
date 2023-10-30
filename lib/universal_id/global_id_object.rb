# frozen_string_literal: true

module UniversalID::Packable
  class GlobalIDObject
    include GlobalID::Identification

    class << self
      def find(id)
        UniversalID::URI::UID.parse id
      end
    end

    attr_reader :id

    def initialize(id)
      @id = id.to_s
    end
  end
end
