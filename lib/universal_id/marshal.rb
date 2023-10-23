# frozen_string_literal: true

module UniversalID::Marshal
  # 1. pack
  # 2. deflate
  # 3. encode
  def self.dump(packable)
    packed = MessagePack.pack(packable)
    deflated = Zlib::Deflate.deflate(packed, Zlib::BEST_COMPRESSION)
    Base64.urlsafe_encode64 deflated, padding: false
  end

  # 1. decode
  # 2. inflate
  # 2. unpack
  def self.load(id)
    decoded = Base64.urlsafe_decode64(id)
    inflated = Zlib::Inflate.inflate(decoded)
    MessagePack.unpack inflated
  rescue => error
    raise UniversalID::LocatorError.new(id, error)
  end
end
