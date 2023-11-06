# frozen_string_literal: true

require_relative "refinements"
require_relative "prepack_options"

class UniversalID::Prepacker
  using ::UniversalID::Refinements::ArrayRefinement
  using ::UniversalID::Refinements::HashRefinement

  class << self
    def prepack(object, options = UniversalID::Configs.default.prepack)
      raise ArgumentError, "Object must implement `prepack`!" unless object.respond_to?(:prepack)
      object.prepack UniversalID::PrepackOptions.new(options)
    end
  end
end
