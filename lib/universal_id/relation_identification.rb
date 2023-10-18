# frozen_string_literal: true

module UniversalID::RelationIdentification
  include UniversalID::Portable

  def find(id)
    compressed_sql = Base64.urlsafe_decode64(id)
    # TODO this doesn't re-instantiate the relation
    ActiveRecord::Base.connection.select_all(Arel.sql(Zlib::Inflate.inflate(compressed_sql)))
  rescue => error
    raise UniversalID::LocatorError.new(id, error)
  end

  def id
    compressed_sql = Zlib::Deflate.deflate(to_sql, Zlib::BEST_COMPRESSION)
    Base64.urlsafe_encode64 compressed_sql, padding: false
  end
end
