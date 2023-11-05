# frozen_string_literal: true

module UniversalID
  module Refinements
    module HashRefinement
      refine ::Hash do
        using UniversalID::Refinements::ArrayRefinement

        def prepack
          config = ::Thread.current[:prepack_config]

          copy = each_with_object({}) do |(key, val), memo|
            key = key.to_s
            next unless config.keep_keypair?(key, val)
            memo[key] = val.respond_to?(:prepack) ? val.prepack : val
          end

          config.keep_value?(copy) ? copy : nil
        end
      end
    end
  end
end
