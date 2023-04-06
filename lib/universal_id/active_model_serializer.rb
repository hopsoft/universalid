# frozen_string_literal: true

module UniversalID::ActiveModelSerializer
  extend ActiveSupport::Concern
  include ActiveModel::Serializers::JSON

  class_methods do
    def new_from_portable_hash(value, options = {})
      hash = if value.is_a?(UniversalID::PortableHash)
        value
      else
        gid = UniversalID::PortableHash.parse_gid(value.to_s, options)
        gid&.find || {portable_hash_error: "Invalid or expired UniversalID::PortableHash! #{value.to_s.inspect}"}
      end
      new hash
    rescue => error
      new(portable_hash_error: "Invalid or expired UniversalID::PortableHash! #{error.inspect}")
    end
  end

  included do
    validate { errors.add(:base, portable_hash_error) if portable_hash_error }
  end

  attr_accessor :portable_hash_error

  def to_portable_hash(options = {})
    portable_hash_options = options.delete(:portable_hash_options)
    UniversalID::PortableHash.new as_json(options).merge(portable_hash_options: portable_hash_options)
  end

  def to_portable_hash_global_id(options = {})
    gid_options = options.delete(:gid_options) || {}
    to_portable_hash(options).to_gid(gid_options)
  end
  alias_method :to_portable_hash_gid, :to_portable_hash_global_id

  def to_portable_hash_global_id_param(options = {})
    to_portable_hash_gid(options).to_param
  end
  alias_method :to_portable_hash_gid_param, :to_portable_hash_global_id_param

  def to_portable_hash_signed_global_id(options = {})
    gid_options = options.delete(:gid_options) || {}
    to_portable_hash(options).to_sgid(gid_options)
  end
  alias_method :to_portable_hash_sgid, :to_portable_hash_signed_global_id

  def to_portable_hash_signed_global_id_param(options = {})
    to_portable_hash_sgid(options).to_param
  end
  alias_method :to_portable_hash_sgid_param, :to_portable_hash_signed_global_id_param
end
