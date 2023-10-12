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
      value.deep_transform_values do |val|
        if UniversalID.possible_gid_string?(val)
          GlobalID.parse(val)&.find
        elsif UniversalID.possible_sgid_string?(val)
          SignedGlobalID.parse(val)&.find
        else
          val
        end
      end
    else
      value
    end
  end
end
