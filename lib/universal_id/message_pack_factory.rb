# frozen_string_literal: true

module UniversalID
  MessagePackFactory = ::MessagePack::Factory.new.tap do |factory|
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
end

UniversalID::MessagePackFactory.register_next_type(::Symbol) # preserve Ruby symbols
require_relative "message_pack_types"
