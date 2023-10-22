# frozen_string_literal: true

module UniversalID::Packable
  extend ActiveSupport::Concern
  include GlobalID::Identification

  class_methods do
    def config
      UniversalID.config
    end

    # 1. decode
    # 2. inflate
    # 2. unpack
    def find(id)
      decoded = Base64.urlsafe_decode64(id)
      inflated = Zlib::Inflate.inflate(decoded)
      MessagePack.unpack inflated
    rescue => error
      raise UniversalID::LocatorError.new(id, error)
    end
  end

  # 1. pack
  # 2. deflate
  # 3. encode
  def id
    packed = MessagePack.pack(to_packable)
    deflated = Zlib::Deflate.deflate(packed, Zlib::BEST_COMPRESSION)
    Base64.urlsafe_encode64 deflated, padding: false
  end

  def to_packable
    raise NotImplementedError
  end

  def cache_key
    "#{self.class.name}/#{Digest::MD5.hexdigest(id)}"
  end
end
