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
  end

  delegate_missing_to :@hash

  def initialize(hash = {})
    @hash = hash.with_indifferent_access
  end

  def to_packable(**)
    packable_value(self, **).deep_stringify_keys
  end

  private

  def packable_value(value, **options)
    options = config.merge(options)

    case value
    when Array then value.map { |val| packable_value(val, **options) }
    when Hash, UniversalID::PackableHash
      value.each_with_object({}) do |(key, val), memo|
        key = key.to_s
        next if options[:only].any? && options[:none].none?(key)
        next if options[:except].any?(key)
        memo[key] = packable_value(val, **options) if val.present? || options[:allow_blank]
      end
    else value
    end
  end
end
