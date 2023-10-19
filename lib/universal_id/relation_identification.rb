# frozen_string_literal: true

module UniversalID::RelationIdentification
  include UniversalID::Portable

  def find(id)
    compressed_dump = Base64.urlsafe_decode64(id)
    dump = Zlib::Inflate.inflate(compressed_dump)

    Marshal.load(dump)
  rescue => error
    raise UniversalID::LocatorError.new(id, error)
  end

  def id
    compressed_dump = Zlib::Deflate.deflate(Marshal.dump(self), Zlib::BEST_COMPRESSION)
    Base64.urlsafe_encode64 compressed_dump, padding: false
  end
end
