# frozen_string_literal: true

require "base64"
require "brotli"

# This module provides the ability to encode and decode objects into a compressed, URL-safe string
module UniversalID::Encoder
  class << self
    def encode(object, options = {})
      object = UniversalID::Prepacker.prepack(object, options)

      # This is basically the same call as UniversalID::MessagePackFactory.pack(object),
      # but it uses a pool of pre-initialized packers/unpackers instead of creating a new one each time
      packed = UniversalID::MessagePackFactory.msgpack_pool.dump(object)
      deflated = Brotli.deflate(packed)
      Base64.urlsafe_encode64 deflated, padding: false
    end

    def decode(string)
      decoded = Base64.urlsafe_decode64(string)
      inflated = Brotli.inflate(decoded)
      # This is basically the same call as UniversalID::MessagePackFactory.unpack(object),
      # but it uses a pool of pre-initialized packers/unpackers instead of creating a new one each time
      UniversalID::MessagePackFactory.msgpack_pool.load inflated
    end
  end
end
