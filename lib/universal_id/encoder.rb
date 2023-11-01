# frozen_string_literal: true

require "monitor"

# This module provides the ability to encode and decode objects into a compressed, URL-safe string
#
module UniversalID::Encoder
  extend MonitorMixin

  class << self
    # Encodes the passed object into a UniversalID string
    #
    # Uses MessagePack, Brotli, and Base64 to encode.
    #
    # NOTE: The combination of MessagePack + Brotli is 25% faster than Protobuf
    #       and is within 5% of Protobuf's compression size (it's also 25% smaller than JSON + Brotli)
    #
    # Steps to encode:
    #   1. pack (with MessagePack)
    #   2. deflate (with Brotli)
    #   3. encode (with Base64)
    #
    # @param packable [Object] The object to encode
    # @param options [Hash] Options used for packing the object
    # @option options [Hash] :active_record Options passed to the ActiveRecord encoder
    # @option options.active_record [Boolean] :keep_changes (false) Whether or not to preserve unsaved changes
    # @return [String] A URL safe representation of the object
    def encode(object, options = UniversalID.config[:encode])
      synchronize do
        Thread.current[:universal_id] ||= {}
        Thread.current[:universal_id][:encode] = options
        packed = MessagePack.pack(object)
        deflated = Brotli.deflate(packed)
        Base64.urlsafe_encode64 deflated, padding: false
      ensure
        Thread.current[:universal_id].delete :encode
      end
    end

    # Decodes a UniversalID string and returns the object it represents
    #
    # NOTE: The combination of MessagePack + Brotli is 25% faster than Protobuf
    #       and is within 5% of Protobuf's compression size (it's also 25% smaller than JSON + Brotli)
    #
    # Steps to decode:
    #   1. decode (from Base64)
    #   2. inflate (with Brotli)
    #   3. unpack (with MessagePack)
    #
    # @param value [Object]
    # @return [Object, nil] the unpacked object
    def decode(string)
      decoded = Base64.urlsafe_decode64(string)
      inflated = Brotli.inflate(decoded)
      MessagePack.unpack inflated
    end
  end
end
