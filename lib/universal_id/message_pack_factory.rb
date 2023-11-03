# frozen_string_literal: true

# Singleton class that wraps the UniversalID → MessagePack::Factory
#
# NOTE: Exposed to the rest of the library as: UniversalID::MessagePacker
#       You can also access it directly as: UniversalID::MessagePackFactory.instance
#       i.e. UniversalID::MessagePacker == UniversalID::MessagePackFactory.instance
#
module UniversalID
  class MessagePackFactory
    extend Forwardable
    include Singleton

    def_delegators :factory, :pack, :unpack, :registered_types, :type_registered?

    def register_type(...)
      factory.register_type(next_id, ...)
    end

    private

    attr_reader :factory

    def initialize
      @factory ||= ::MessagePack::Factory.new.tap do |factory|
        factory.register_type(0, ::Symbol) # preserve Ruby symbols
      end
    end

    def next_id
      i = 0
      i += 1 while factory.type_registered?(i)
      (0..127).cover?(i) ? i : nil
    end
  end

  # Makes UniversalID::MessagePackFactory.instance available as UniversalID::MessagePacker
  MessagePacker = UniversalID::MessagePackFactory.instance
end

# load order is important because the factory need to be ready before we can register types
require_relative "message_pack_types"
