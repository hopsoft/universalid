# frozen_string_literal: true

module UniversalID
  module Refinements
    module HashRefinement
      refine ::Hash do
        using ::UniversalID::Refinements::ArrayRefinement

        def to_message_prepack
          config = Thread.current[:universal_id_message_pack_config]

          each_with_object({}) do |(key, val), memo|
            key = key.to_s
            next unless config.include?(key, val)
            memo[key] = val.respond_to?(:to_message_prepack) ?
              val.to_message_prepack :
              val
          end
        end
      end
    end
  end
end
