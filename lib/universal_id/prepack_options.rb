# frozen_string_literal: true

require_relative "prepack_database_options"

class UniversalID::PrepackOptions
  attr_reader :excludes, :includes, :database_options

  def initialize(options = {})
    @settings = UniversalID::Settings.build(**options).prepack
    @database_options = UniversalID::PrepackDatabaseOptions.new(@settings.database)
    @references = Set.new
    @excludes ||= @settings.exclude.to_h { |key| [key.to_s, true] }
    @includes ||= @settings.include.to_h { |key| [key.to_s, true] }
  end

  def to_h
    @settings.to_h
  end

  def prevent_self_reference!(object)
    raise UniversalID::Prepacker::CircularReferenceError if @references.include?(object.object_id)
    @references << object.object_id
  end

  def include_blank?
    !!@settings.include_blank
  end

  def exclude_blank?
    !include_blank?
  end

  def keep_key?(key)
    includes[key.to_s] || !excludes[key.to_s]
  end

  def reject_key?(key)
    excludes[key.to_s]
  end

  def keep_value?(value)
    include_blank? || present?(value)
  end

  def reject_value?(value)
    !keep_value?(value)
  end

  def keep_keypair?(key, value)
    keep_key?(key) && keep_value?(value)
  end

  def reject_keypair?(key, value)
    reject_key?(key) || reject_value?(value)
  end

  def blank?(value)
    return true if value.nil?
    return false if !!value == value # booleans

    result = false
    result ||= value.empty? if value.respond_to?(:empty?)
    result ||= value.blank? if value.respond_to?(:blank?)
    result ||= value.strip.empty? if value.is_a?(String)
    result ||= value.compact.empty? if value.is_a?(Array) || value.is_a?(Hash)
    result
  end

  def present?(value)
    !blank?(value)
  end
end
