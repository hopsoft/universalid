# frozen_string_literal: true

module UniversalID::Refinements
  module Kernel
    refine ::Kernel do
      def const_find(name)
        return nil unless name.is_a?(::String)
        names = name.split("::")
        constant = ::Object

        while names.any?
          value = names.shift
          constant = constant.const_get(value) if constant.const_defined?(value)
        end

        (constant.name == name) ? constant : nil
      end

      def descends_from?(*klasses)
        (ancestors & klasses).any?
      end
    end
  end
end
