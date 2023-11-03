# frozen_string_literal: true

require "etc"

UniversalID::MessagePackFactory = ::MessagePack::Factory.new.tap do |factory|
  class << factory
    def register_next_type(...)
      register_type(next_type_id, ...)
    end

    attr_reader :workers

    def workers=(size)
      @workers = pool(size.to_i)
    end

    def pack(...)
      workers ? workers.dump(...) : super
    end

    def unpack(...)
      workers ? workers.load(...) : super
    end

    private

    def next_type_id
      max_type_id = registered_types.map { |type| type[:type].to_i }.max
      max_type_id.nil? ? 0 : max_type_id + 1
    end
  end
end

# Register built-in types
UniversalID::MessagePackFactory.register_type MessagePack::Timestamp::TYPE, ::Time,
  packer: MessagePack::Time::Packer,
  unpacker: MessagePack::Time::Unpacker

UniversalID::MessagePackFactory.register_next_type(::Symbol) # preserves Ruby symbols

# Register custom/extension types
require_relative "message_pack_types"

# Setup a pool of pre-initialized packers/unpackers for marshaling operations
UniversalID::MessagePackFactory.workers = [Etc.nprocessors, 1].max
