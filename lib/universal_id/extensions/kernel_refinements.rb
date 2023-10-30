# frozen_string_literal: true

module UniversalID::Extensions::KernelRefinements
  refine Kernel do
    def const_find(name)
      return nil unless name.is_a?(String)
      names = name.force_encoding("UTF-8").split("::")
      constant = Object

      while names.any?
        value = names.shift
        constant = constant.const_get(value) if constant.const_defined?(value)
      end

      (constant.name == name) ? constant : nil
    end
  end
end
