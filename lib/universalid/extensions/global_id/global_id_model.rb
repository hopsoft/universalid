# frozen_string_literal: true

if defined? GlobalID::Identification

  class UniversalID::Extensions::GlobalIDModel
    include GlobalID::Identification

    def self.find(value)
      new value
    end

    attr_reader :id, :uid

    def initialize(universal_id)
      @uid = case universal_id
      when URI::UID then universal_id
      when String
        URI::UID.match?(universal_id) ? URI::UID.parse(universal_id) : URI::UID.from_payload(universal_id)
      end

      @id = uid&.payload
    end
  end

end
