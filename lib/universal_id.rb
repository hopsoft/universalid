# frozen_string_literal: true

class UniversalID
  include GlobalID::Identification

  def self.find(id)
    new JSON.parse(Base64.decode64(id))
  end

  def initialize(attributes)
    @attributes = attributes
  end

  def attributes
    @attributes = @attributes.stringify_keys.except("id", "created_at", "updated_at")
  end

  def id
    Base64.encode64 attributes.to_json
  end
end
