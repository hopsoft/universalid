# frozen_string_literal: true

# if defined? ActiveRecord::Base

# module UniversalID::Refinements::ActiveRecordRefinement
# refine ActiveRecord::Base do
# using UniversalID::Refinements::HashRefinement

# def prepack(options)
# primer = UniversalID::Refinements::ActiveRecordRefinementPrimer.new(self, options)
# primer.to_h.prepack options
# end
# end
# end
# end
