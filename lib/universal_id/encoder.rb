# frozen_string_literal: true

# This module provides the ability to encode and decode objects into a compressed, URL-safe string
#
module UniversalID::Encoder
  using UniversalID::Extensions::KernelRefinements

  class << self
    # Encodes the given object into a compressed, Web/URL-safe string i.e. a UniversalID string
    #
    # This method uses MessagePack to mashal the object, Zlib to compress the mashaled data,
    # and then encodes the compressed data into a URL-safe Base64 string to create a universal "package"
    #
    # 1. pack
    # 2. deflate
    # 3. encode
    #
    # @param packable [Object] The object to be dumped
    # @return [String] The compressed, URL-safe Base64 string representation of the object
    def encode(object)
      packed = MessagePack.pack(object)
      deflated = Zlib::Deflate.deflate(packed, Zlib::BEST_COMPRESSION)
      Base64.urlsafe_encode64 deflated, padding: false # the "package" representing the object
    end

    # Decodes a UniversalID string and returns the object it represents
    #
    # 1. decode
    # 2. inflate
    # 3. unpack
    #
    # @param value [Object]
    # @return [Object, nil] the unpacked object
    def decode(value, options = {})
      case value
      when UniversalID::PackableBase then value
      when UniversalID::URI::UID then value.openable? ? unpack(value.package) : nil
      when GlobalID, SignedGlobalID then unpack(value.find)
      when URI::GID then unpack(value.to_s, options)
      when String
        object = unpack(UniversalID::URI::UID.parse(value)) if UniversalID::URI::UID.match?(value)
        object ||= unpack(GlobalID.parse(value) || SignedGlobalID.parse(value, options))
        object || begin
          decoded = Base64.urlsafe_decode64(value)
          inflated = Zlib::Inflate.inflate(decoded)
          MessagePack.unpack inflated
        end
      end
    end
  end
end
