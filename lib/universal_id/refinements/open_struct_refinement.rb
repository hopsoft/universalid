# frozen_string_literal: true

module UniversalID::Refinements::OpenStructRefinement
  refine OpenStruct do
    using UniversalID::Refinements::HashRefinement

    def prepack(options)
      options.prevent_self_reference! self
      OpenStruct.new to_h.prepack(options)
    end
  end
end
