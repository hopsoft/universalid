# frozen_string_literal: true

module UniversalID::Refinements::HashRefinement
  refine Hash do
    using UniversalID::Refinements::ArrayRefinement

    def prepack(options)
      options.prevent_self_reference! self

      copy = each_with_object({}) do |(key, val), memo|
        next unless options.keep_keypair?(key, val)
        memo[key] = UniversalID::Prepacker.prepack(val, options)
      end

      copy.compact! if options.exclude_blank?
      copy
    end
  end
end
