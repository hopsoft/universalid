# frozen_string_literal: true

module UniversalID
  module Refinements
    module ArrayRefinement
      refine ::Array do
        def to_message_prepack
          map do |entry|
            entry.respond_to?(:to_message_prepack) ?
              entry.to_message_prepack :
              entry
          end
        end
      end
    end
  end
end
