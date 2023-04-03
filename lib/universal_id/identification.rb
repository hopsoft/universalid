# frozen_string_literal: true

module UniversalID::Identification
  extend ActiveSupport::Concern

  def self.config
    UniversalID.config.identification.with_indifferent_access
  end

  class_methods do
    def new_from_ugid(ugid, options = {})
      new GlobalID.parse(ugid, UniversalID::Identification.config[:gid]).find
    rescue => error
      new.tap { |instance| instance.ugid_error = UniversalID::LocatorError.new(ugid, error) }
    end

    def new_from_usgid(usgid, options = {})
      new SignedGlobalID.parse(usgid, UniversalID::Identification.config[:sgid]).find
    rescue => error
      new.tap { |instance| instance.usgid_error = UniversalID::LocatorError.new(usgid, error) }
    end
  end

  included do
    validate :validate_ugid
    validate :validate_usgid
  end

  attr_accessor :ugid_error, :usgid_error

  def validate_ugid
    return unless ugid_error
    errors.add :base, "UniversalID GlobalID not found! #{ugid_error.message}"
  end

  def validate_usgid
    return unless usgid_error
    errors.add :base, "UniversalID SignedGlobalID not found! #{usgid_error.message}"
  end

  def attributes_with_gid(**hash_with_gid_options)
    UniversalID::HashWithGID.new(**attributes, hash_with_gid_options: hash_with_gid_options)
  end

  def to_ugid(hash_with_gid_options: {}, **gid_options)
    attrs = attributes_with_gid(**hash_with_gid_options)
    attrs.to_gid UniversalID::Identification.config[:gid].merge(gid_options)
  end

  def to_ugid_param(hash_with_gid_options: {}, **gid_options)
    to_ugid(hash_with_gid_options: hash_with_gid_options, **gid_options).to_param
  end

  def to_usgid(hash_with_gid_options: {}, **sgid_options)
    attrs = attributes_with_gid(**hash_with_gid_options)
    attrs.to_sgid UniversalID::Identification.config[:sgid].merge(sgid_options)
  end

  def to_usgid_param(hash_with_gid_options: {}, **sgid_options)
    to_usgid(hash_with_gid_options: hash_with_gid_options, **sgid_options).to_param
  end
end
