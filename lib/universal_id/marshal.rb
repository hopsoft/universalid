# frozen_string_literal: true

module UniversalID::Marshal
  # Dumps the given object into a compressed, URL-safe string
  #
  # This method uses MessagePack to serialize the object, Zlib to compress the serialized data,
  # and then encodes the compressed data into a URL-safe Base64 string
  # 1. pack
  # 2. deflate
  # 3. encode
  #
  # @param packable [Object] The object to be dumped
  # @return [String] The compressed, URL-safe Base64 string representation of the object
  def self.dump(packable)
    packed = MessagePack.pack(packable)
    deflated = Zlib::Deflate.deflate(packed, Zlib::BEST_COMPRESSION)
    Base64.urlsafe_encode64 deflated, padding: false
  end

  # Load a serialized object from a URL-safe Base64 encoded string.
  #
  # This method takes a URL-safe Base64 encoded string, decodes it, inflates it
  # 1. decode
  # 2. inflate
  # 3. unpack
  #
  # @param id [String] a URL-safe Base64 encoded string representing the serialized object
  # @return [Object] the deserialized object
  # @raise [UniversalID::LocatorError] if any step in the process fails
  def self.load(id)
    decoded = Base64.urlsafe_decode64(id)
    inflated = Zlib::Inflate.inflate(decoded)
    MessagePack.unpack inflated
  rescue => error
    raise UniversalID::LocatorError.new(id, error)
  end
end
