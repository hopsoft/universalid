# frozen_string_literal: true

module UniversalID::MessagePack
  class << self
    def next_type_id
      MessagePack::DefaultFactory.registered_types
        .map { |entry| entry[:type] }
        .max.to_i + 1
    end

    def register_type(...)
      MessagePack::DefaultFactory.register_type(next_type_id, ...)
    end
  end
end

require_relative "message_pack/types/object"
