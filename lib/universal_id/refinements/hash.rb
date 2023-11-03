# frozen_string_literal: true

module UniversalID
  module Refinements
    module Hash
      refine ::Hash do
        def deep_transform_keys!(&block)
          keys.each do |key|
            value = self[key]

            if value.is_a? Hash
              value.deep_transform_keys!(&block)
            else
              new_key = block.call(key)
              delete key
              self[new_key] = value
            end
          end
        end
      end
    end
  end
end
