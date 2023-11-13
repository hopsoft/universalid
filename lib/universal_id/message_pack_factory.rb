# frozen_string_literal: true

require "etc"
require "msgpack"

UniversalID::MessagePackFactory = MessagePack::Factory.new.tap do |factory|
  class << factory
    attr_reader :msgpack_pool

    def create_msgpack_pool
      @msgpack_pool = UniversalID::MessagePackFactory.pool([Etc.nprocessors.to_i, 1].max)
    end

    def register(type:, type_id: nil, recreate_pool: true, **options)
      id = type_id || next_type_id
      options[:recursive] = true unless options.key?(:recursive)
      register_type(id, type, options)
      create_msgpack_pool if recreate_pool
    end

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
UniversalID::MessagePackFactory.register_type 0x00, ::Symbol

# Register UniversalID types/extensions
require_relative "message_pack_types"
