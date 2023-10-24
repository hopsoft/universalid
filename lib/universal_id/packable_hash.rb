# frozen_string_literal: true

class UniversalID::PackableHash
  include UniversalID::Packable

  class << self
    def config
      @config ||= super[:packable_hash].with_indifferent_access.tap do |c|
        c[:only] = (c[:only] || []).map(&:to_s)
        c[:except] = (c[:except] || []).map(&:to_s)
      end
    end

    def find(id)
      new super
    end
  end

  delegate_missing_to :@hash

  def initialize(hash = {})
    @hash = hash.with_indifferent_access
  end

  def to_packable(**options)
    options = normalize_options(**options)
    packable_value(self, **options).deep_stringify_keys
  end

  private

  def normalize_options(**options)
    config.merge(options).tap do |opts|
      opts[:allow_blank] = !!opts[:allow_blank]
      %i[only except].each do |key|
        opts[key] ||= []
        opts[key] = [opts[key]].compact.flatten unless opts[key].is_a?(Array)
        opts[key] = opts[key].map(&:to_s)
      end
    end
  end

  def packable_value(value, **options)
    options = options.with_indifferent_access # TODO: Remove this line after we stop supporting Ruby 2.7
    case value
    when Array then value.map { |val| packable_value(val, **options) }
    when Hash, UniversalID::PackableHash
      value.each_with_object({}) do |(key, val), memo|
        key = key.to_s
        next if options[:only].any? && options[:only].none?(key)
        next if options[:except].any?(key)
        val = packable_value(val, **options)
        memo[key] = val if val.present? || options[:allow_blank]
      end
    else value
    end
  end
end
