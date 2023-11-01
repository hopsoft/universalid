# frozen_string_literal: true

# Ensure that pack/unpack preserves symbols
MessagePack::DefaultFactory.register_type(0, Symbol)

module UniversalID::MessagePackTypes
  class << self
    def register(...)
      factory.register_type(next_id, ...)
    end

    def files
      Dir.glob(File.join(File.dirname(__FILE__), "message_pack_types", "**", "*.rb")).sort
    end

    # A list of all MessagePack types in the preferred registration order (specific to general)
    # NOTE: More specific type should be registered before more general types
    #       because MessagePack will use the first registered type that matches
    #       MessagePack scans registered type in linear order and first match wins
    def list
      %w[
        universal_id/uri/uid
        rails/global_id/signed_global_id
        rails/global_id/global_id
        rails/global_id/identification
        ruby/complex
        ruby/rational
        ruby/date_time
        ruby/date
        ruby/time
        ruby/range
        ruby/regexp
        ruby/set
        ruby/open_struct
        ruby/struct
      ]
    end

    def register_all
      list.each { |type| require_relative "message_pack_types/#{type}.rb" }
    end

    private

    def factory
      MessagePack::DefaultFactory
    end

    def next_id
      i = 0
      i += 1 while factory.type_registered?(i)
      (0..127).cover?(i) ? i : nil
    end
  end
end
