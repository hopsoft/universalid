# frozen_string_literal: true

module UniversalID
  module Refinements
    module ArrayRefinement
      refine ::Array do
        def prepack
          config = ::Thread.current[:prepack_config]

          copy = select do |item|
            item = item.respond_to?(:prepack) ? item.prepack : item
            config.keep? item
          end

          config.keep?(copy) ? copy : nil
        end
      end
    end
  end
end
