# frozen_string_literal: true

# This module provides the ability to encode and decode objects into a compressed, URL-safe string
#
module UniversalID::Encoder
  class << self
    # Encodes the passed object into a UniversalID string
    #
    # 1. pack
    # 2. deflate
    # 3. encode
    #
    # @param packable [Object] The object to encode
    # @return [String] A URL safe representation of the object
    def encode(object)
      packed = MessagePack.pack(object)
      deflated = Brotli.deflate(packed)
      Base64.urlsafe_encode64 deflated, padding: false
    end

    # Decodes a UniversalID string and returns the object it represents
    #
    # 1. decode
    # 2. inflate
    # 3. unpack
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
