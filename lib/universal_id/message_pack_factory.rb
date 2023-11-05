# frozen_string_literal: true

require "etc"
require "msgpack"

UniversalID::MessagePackFactory = MessagePack::Factory.new.tap do |factory|
  class << factory
    def register_next_type(...)
      register_type(next_type_id, ...)
    end

    private

    def next_type_id
      max_type_id = registered_types.map { |type| type[:type].to_i }.max
      max_type_id.nil? ? 0 : max_type_id + 1
    end
  end
end

# Register MessagePack built-in types
UniversalID::MessagePackFactory.register_type MessagePack::Timestamp::TYPE, ::Time,
  packer: MessagePack::Time::Packer,
  unpacker: MessagePack::Time::Unpacker

# Register MessagePack built-in extensions
UniversalID::MessagePackFactory.register_next_type(::Symbol)

# Register UniversalID types/extensions
require_relative "message_pack_types"

# Setup a pool of pre-initialized packers/unpackers for marshaling operations
pool_size = [Etc.nprocessors, 1].max
UniversalID::MessagePackFactoryPool = UniversalID::MessagePackFactory.pool(pool_size)
