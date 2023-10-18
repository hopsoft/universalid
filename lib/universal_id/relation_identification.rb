# frozen_string_literal: true

module UniversalID::RelationIdentification
  include UniversalID::Portable

  def find(id)
    compressed_sql = Base64.urlsafe_decode64(id)
    sql = Zlib::Inflate.inflate(compressed_sql)

    extract_model_name(sql).safe_constantize.find_by_sql(Arel.sql(sql))
  rescue => error
    raise UniversalID::LocatorError.new(id, error)
  end

  def id
    compressed_sql = Zlib::Deflate.deflate(to_sql, Zlib::BEST_COMPRESSION)
    Base64.urlsafe_encode64 compressed_sql, padding: false
  end

  private

  def extract_model_name(sql)
    table_name = extract_table_name(sql)
    table_name&.classify
  end

  def extract_table_name(sql)
    match_data = sql.match(/FROM\s+"?([a-zA-Z0-9_]+)"?/)
    match_data[1] if match_data
  end
end
