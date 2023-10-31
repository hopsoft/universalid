# frozen_string_literal: true

# This module provides the ability to encode and decode objects into a compressed, URL-safe string
#
module UniversalID::Encoder
  class << self
    # Encodes the passed object into a UniversalID string
    #
    # Uses MessagePack, Brotli, and Base64 to encode.
    #
    # NOTE: The combination of MessagePack + Brotli is 25% faster than Protobuf
    #       and is within 5% of Protobuf's compression size
    #
    # Steps to encode:
    #   1. pack (with MessagePack)
    #   2. deflate (with Brotli)
    #   3. encode (with Base64)
    #
    # @param packable [Object] The object to encode
    # @param active_record [Hash] options for any ActiveRecord instances being encoded
    # @return [String] A URL safe representation of the object
    def encode(object, active_record: {keep_changes: false})
      packed = MessagePack.pack(object)
      deflated = Brotli.deflate(packed)
      Base64.urlsafe_encode64 deflated, padding: false
    end

    # Decodes a UniversalID string and returns the object it represents
    #
    # NOTE: The combination of MessagePack + Brotli is 25% faster than Protobuf
    #       and is within 5% of Protobuf's compression size
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
