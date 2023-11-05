# frozen_string_literal: true

class UniversalID::PrepackConfig
  attr_reader :config

  def initialize(config = UniversalID.config)
    # TODO: add Config dry-schema, dry-validations, etc.
    raise ArgumentError, "Config must be an instance of Config::Options!" unless config.is_a?(Config::Options)
    raise ArgumentError, "Config must include the `prepack` key!" unless config.prepack&.is_a?(Config::Options)
    @config = config.prepack
  end

  def exclude?(key)
    @exclude ||= config.exclude.to_h { |key| [key, true] }
    @exclude[key]
  end

  def include?(key, value)
    @include ||= config.include.to_h { |key| [key, true] }
    return false if exclude?(key)
    return false if discard?(value)
    @include[key] || @include.empty?
  end

  def blank?(value)
    return true if value.nil?
    return true if value.respond_to?(:blank?) && value.blank?
    return true if value.respond_to?(:empty?) && value.empty?
    return true if value.is_a?(String) && value.strip.empty?
    false
  end

  def present?(value)
    !blank? value
  end

  def keep?(value)
    include_blank? || present?(value)
  end

  def discard?(value)
    !keep? value
  end

  def include_blank?
    return @include_blank[:include_blank] if @include_blank
    @include_blank ||= {include_blank: !!config.include_blank}
  end

  def exclude_blank?
    !include_blank?
  end
end
