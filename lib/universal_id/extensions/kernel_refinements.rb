# frozen_string_literal: true

module UniversalID::Extensions::KernelRefinements
  refine Kernel do
    def const_find(name)
      names = name.split("::")
      constant = Object

      while names.any?
        value = names.shift
        constant = constant.const_get(value) if constant.const_defined?(value)
      end

      (constant.name == name) ? constant : nil
    end
  end
end
