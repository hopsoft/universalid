# frozen_string_literal: true

module UniversalID
  module Refinements
    module ArrayRefinement
      refine ::Array do
        def prepack
          config = ::Thread.current[:prepack_config]

          copy = select do |val|
            val = val.respond_to?(:prepack) ? val.prepack : val
            config.keep_value? val
          end

          config.keep_value?(copy) ? copy : nil
        end
      end
    end
  end
end
