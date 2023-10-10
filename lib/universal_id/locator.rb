# frozen_string_literal: true

class UniversalID::Locator < GlobalID::Locator::BaseLocator
  def locate(gid, options = {})
    located_hash = super
    deep_hydrate(located_hash)
  end

  private

  def deep_hydrate(value)
    case value
    when Array
      value.map(&:deep_hydrate) if value.is_a?(Array)
    when Hash
      value.deep_transform_values { |v| possible_gid_string?(v) ? GlobalID::Locator.locate(v) : v }
    else
      value
    end
  end

  def possible_gid_string?(value)
    return false unless value.is_a?(String)
    GID_PARAM_REGEX.match? value
  end
end
