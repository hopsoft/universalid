# frozen_string_literal: true

module UniversalID::Refinements::SetRefinement
  refine Set do
    using UniversalID::Refinements::ArrayRefinement

    def prepack(options)
      options.prevent_self_reference! self
      Set.new to_a.prepack(options)
    end
  end
end
