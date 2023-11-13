# frozen_string_literal: true

module UniversalID::Refinements::ArrayRefinement
  refine Array do
    def prepack(options)
      options.prevent_self_reference! self

      copy = each_with_object([]) do |val, memo|
        val = UniversalID::Prepacker.prepack(val, options)
        memo << val if options.keep_value?(val)
      end

      copy.compact! if options.exclude_blank?
      copy
    end
  end
end
