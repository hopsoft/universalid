# frozen_string_literal: true

require "msgpack"

# Ensure that pack/unpack preserves symbols
MessagePack::DefaultFactory.register_type(0, Symbol)

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

path = File.join(File.dirname(__FILE__), "message_pack", "types", "**", "*.rb")
Dir.glob(path).each { |file| require file }
