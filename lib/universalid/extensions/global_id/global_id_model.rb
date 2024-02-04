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
        case universal_id
        when /\A#{URI::UID::SCHEME}/o then URI::UID.parse(universal_id)
        else URI::UID.from_payload(universal_id)
        end
      end

      @id = uid&.payload
    end
  end

end
