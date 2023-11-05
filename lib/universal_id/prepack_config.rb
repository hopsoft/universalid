# frozen_string_literal: true

class UniversalID::PrepackConfig
  using UniversalID::Refinements::KernelRefinement
  attr_reader :config

  def initialize(config = nil)
    config ||= UniversalID::Configs.default.prepack

    # TODO: add Config dry-schema, dry-validations, etc.
    raise ArgumentError, "Config must be an instance of Config::Options!" unless config.is_a?(Config::Options)

    @config = config
  end

  # config settings ..........................................................................................
  def include_blank?
    return @include_blank[:include_blank] if @include_blank
    @include_blank ||= {include_blank: !!config.include_blank}
  end

  def exclude_blank?
    !include_blank?
  end

  def includes
    @includes ||= config.include.to_h { |key| [key, true] }
  end

  def excludes
    @excludes ||= config.exclude.to_h { |key| [key, true] }
  end

  # kepy/value assessments ...................................................................................
  def keep_key?(key)
    includes[key] || !excludes[key]
  end

  def discard_key?(key)
    excludes[key]
  end

  def keep_value?(value)
    include_blank? || value_present?(value)
  end

  def discard_value?(value)
    !keep_value?(value)
  end

  def keep_keypair?(key, value)
    keep_key?(key) && keep_value?(value)
  end

  def discard_keypair?(key, value)
    discard_key?(key) || discard_value?(value)
  end

  # key/value information ....................................................................................
  def value_blank?(value)
    return true if value.nil?
    return false if !!value == value # booleans

    result = false
    result ||= value.empty? if value.respond_to?(:empty?)
    result ||= value.blank? if value.respond_to?(:blank?)
    result ||= value.strip.empty? if value.is_a?(String)
    result ||= value.compact.empty? if value.is_a?(Array) || value.is_a?(Hash)
    result
  end

  def value_present?(value)
    !value_blank?(value)
  end
end
