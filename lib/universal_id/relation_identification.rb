# frozen_string_literal: true

module UniversalID::RelationIdentification
  include UniversalID::Portable

  def find(id)
    compressed_sql = Base64.urlsafe_decode64(id)
    sql = Zlib::Inflate.inflate(compressed_sql)

    extract_model_class(sql).find_by_sql(Arel.sql(sql))
  rescue => error
    raise UniversalID::LocatorError.new(id, error)
  end

  def id
    compressed_sql = Zlib::Deflate.deflate(to_sql, Zlib::BEST_COMPRESSION)
    Base64.urlsafe_encode64 compressed_sql, padding: false
  end

  private

  def extract_model_class(sql)
    find_model_by_table_name(extract_table_name(sql))
  end

  def find_model_by_table_name(table_name)
    class_name = table_name&.classify

    return class_name.safe_constantize if Object.const_defined?(class_name)

    # this is costly in terms of memory
    ActiveRecord::Base.descendants.detect { |model| model.table_name == table_name }
  end

  def extract_table_name(sql)
    match_data = sql.match(/FROM\s+"?([a-zA-Z0-9_]+)"?/)
    match_data[1] if match_data
  end
end
