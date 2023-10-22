# frozen_string_literal: true

class UniversalID::PackableHash
  include UniversalID::Packable

  class << self
    def config
      @config ||= super[:hash].with_indifferent_access.tap do |c|
        only = c[:only] || []
        except = c[:except] || []
        c[:only] = only.map(&:to_s)
        c[:except] = except.map(&:to_s)
      end
    end

    def find(id)
      new super(id)
    end
  end

  delegate :config, to: "self.class"
  delegate_missing_to :@hash

  def initialize(hash = {})
    @hash = hash.with_indifferent_access
  end

  def ==(other)
    @hash == other.try(:with_indifferent_access)
  end

  def to_packable
    packable_value(self).deep_stringify_keys
  end

  private

  def packable_value(value)
    case value
    when Array then value.map { |val| packable_value(val) }
    when Hash, UniversalID::PackableHash
      value.each_with_object({}) do |(key, val), memo|
        key = key.to_s
        next if config[:only].any? && config[:none].none?(key)
        next if config[:except].any?(key)
        memo[key] = packable_value(val) if val.present? || config[:allow_blank]
      end
    else value
    end
  end
end
