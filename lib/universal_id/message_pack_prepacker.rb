# frozen_string_literal: true

require_relative "refinements"

class UniversalID::MessagePackPrepacker
  using ::UniversalID::Refinements::ArrayRefinement
  using ::UniversalID::Refinements::HashRefinement

  attr_reader :object

  def initialize(object)
    @object = case object
    when Array, Hash then object
    else raise ArgumentError, "Object must be a Hash or Array!"
    end
  end

  def prepack(config = UniversalID.config)
    Thread.current[:universal_id_message_pack_config] = MessagePackConfig.new(config)
    object.to_message_prepack
  ensure
    Thread.current[:universal_id_message_pack_config] = nil
  end

  class MessagePackConfig
    attr_reader :config

    def initialize(config = UniversalID.config)
      # TODO: add Config dry-schema, dry-validations, etc.
      raise ArgumentError, "Config must be a Config::Options!" unless config.is_a?(Config::Options)
      raise ArgumentError, "Config must include the `message_pack` key!" unless config.message_pack&.is_a?(Config::Options)
      @config = config.message_pack
    end

    # Indicates if the keypair should be included in the pack
    def include?(key, value)
      @include ||= config.include.to_h { |key| [key, true] }
      return false if exclude?(key)
      return false if exclude_blank? && blank?(value)
      @include[key] || @include.empty?
    end

    def blank?(value)
      return true if value.nil?
      return true if value.respond_to?(:blank?) && value.blank?
      return true if value.respond_to?(:empty?) && value.empty?
      return true if value.is_a?(String) && value.strip.empty?
      false
    end

    def exclude?(key)
      @exclude ||= config.exclude.to_h { |key| [key, true] }
      @exclude[key]
    end

    def include_blank?
      return @include_blank[:include_blank] if @include_blank
      @include_blank ||= {include_blank: !!config.include_blank}
    end

    def exclude_blank?
      !include_blank?
    end
  end
end
