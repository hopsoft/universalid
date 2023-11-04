# frozen_string_literal: true

# This module provides the ability to encode and decode objects into a compressed, URL-safe string
module UniversalID::Encoder
  class << self
    def encode(object)
      packed = UniversalID::MessagePackFactory.pack(object)
      deflated = Brotli.deflate(packed)
      Base64.urlsafe_encode64 deflated, padding: false
    end

    def decode(string)
      decoded = Base64.urlsafe_decode64(string)
      inflated = Brotli.inflate(decoded)
      UniversalID::MessagePackFactory.unpack inflated
    end
  end
end
