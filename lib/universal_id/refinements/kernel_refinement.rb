# frozen_string_literal: true

module UniversalID
  module Refinements
    module KernelRefinement
      refine ::Kernel do
        # Finds a constant by name, starting at the root namespace (i.e. ::Object)
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

        # Indicates if the current Class or Module is a descendant of the passed list of Classes or Modules
        def descends_from?(*klasses)
          klass = is_a?(::Class) ? self : self.class
          (klass.ancestors & klasses).any?
        end
      end
    end
  end
end
