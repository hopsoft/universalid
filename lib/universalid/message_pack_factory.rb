# frozen_string_literal: true

require "etc"
require "msgpack"

UniversalID::MessagePackFactory = MessagePack::Factory.new.tap do |factory|
  class << factory
    attr_reader :msgpack_pool

    def create_msgpack_pool
      @msgpack_pool = UniversalID::MessagePackFactory.pool([Etc.nprocessors.to_i, 1].max)
    end

    def register_scalar(type:, recreate_pool: true, **options)
      register id: next_type_id(order: :asc), type: type, **options
    end

    def register(type:, id: nil, recreate_pool: true, **options)
      options[:recursive] = true unless options.key?(:recursive)
      register_type(id || next_type_id(order: :desc), type, options)
      create_msgpack_pool if recreate_pool
    end

    def next_type_id(order:)
      range = 0..127

      case order
      when :asc
        id = range.first
        id += 1 while type_registered?(id)
      when :desc
        id = range.last
        id -= 1 while type_registered?(id)
      end

      id = nil unless range.cover?(id)
      id
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
