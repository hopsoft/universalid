# frozen_string_literal: true

# TODO: Consider cleaning up the alias verbosity?
module UniversalID::Identification
  extend ActiveSupport::Concern

  def self.config
    UniversalID.config.identification
  end

  class_methods do
    def new_from_universalid_hash_global_id(ugid, options = {})
      new GlobalID.parse(ugid, UniversalID::Identification.config[:gid]).find
    rescue => error
      new.tap { |instance| instance.ugid_error = UniversalID::LocatorError.new(ugid, error) }
    end
    alias_method :new_from_universalid_hash_gid, :new_from_universalid_hash_global_id
    alias_method :new_from_ugid, :new_from_universalid_hash_gid

    def new_from_universalid_hash_signed_global_id(usgid, options = {})
      new SignedGlobalID.parse(usgid, UniversalID::Identification.config[:sgid]).find
    rescue => error
      new.tap { |instance| instance.usgid_error = UniversalID::LocatorError.new(usgid, error) }
    end
    alias_method :new_from_universalid_hash_sgid, :new_from_universalid_hash_signed_global_id
    alias_method :new_from_usgid, :new_from_universalid_hash_sgid
  end

  included do
    validate :validate_ugid
    validate :validate_usgid
  end

  attr_accessor :universalid_hash_global_id_error
  alias_method :universalid_hash_gid_error, :universalid_hash_global_id_error
  alias_method :universalid_hash_gid_error=, :universalid_hash_global_id_error=
  alias_method :ugid_error, :universalid_hash_gid_error
  alias_method :ugid_error=, :universalid_hash_gid_error=

  attr_accessor :universalid_hash_signed_global_id_error
  alias_method :universalid_hash_sgid_error, :universalid_hash_signed_global_id_error
  alias_method :universalid_hash_sgid_error=, :universalid_hash_signed_global_id_error=
  alias_method :usgid_error, :universalid_hash_sgid_error
  alias_method :usgid_error=, :universalid_hash_sgid_error=

  def validate_universalid_hash_global_id
    return unless ugid_error
    errors.add :base, "UniversalID GlobalID not found! #{ugid_error.message}"
  end
  alias_method :validate_universalid_hash_gid, :validate_universalid_hash_global_id
  alias_method :validate_ugid, :validate_universalid_hash_gid

  def validate_universalid_hash_signed_global_id
    return unless usgid_error
    errors.add :base, "UniversalID SignedGlobalID not found! #{usgid_error.message}"
  end
  alias_method :validate_universalid_hash_sgid, :validate_universalid_hash_signed_global_id
  alias_method :validate_usgid, :validate_universalid_hash_sgid

  def universalid_hash
    UniversalID::Hash.new attributes
  end

  def to_universalid_hash_global_id(options = {})
    universalid_hash.to_gid UniversalID::Identification.config[:gid].merge(options)
  end
  alias_method :to_universalid_hash_gid, :to_universalid_hash_global_id
  alias_method :to_ugid, :to_universalid_hash_gid

  def to_universalid_hash_global_id_param(options = {})
    to_universalid_hash_gid(options).to_param
  end
  alias_method :to_universalid_hash_gid_param, :to_universalid_hash_global_id_param
  alias_method :to_ugid_param, :to_universalid_hash_gid_param

  def to_universalid_hash_signed_global_id(options = {})
    universalid_hash.to_sgid UniversalID::Identification.config[:sgid].merge(options)
  end
  alias_method :to_universalid_hash_sgid, :to_universalid_hash_signed_global_id
  alias_method :to_usgid, :to_universalid_hash_sgid

  def to_universalid_hash_signed_global_id_param(options = {})
    to_universalid_hash_sgid(options).to_param
  end
  alias_method :to_universalid_hash_sgid_param, :to_universalid_hash_signed_global_id_param
  alias_method :to_usgid_param, :to_universalid_hash_sgid_param
end
