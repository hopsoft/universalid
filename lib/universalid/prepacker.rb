# frozen_string_literal: true

class UniversalID::Prepacker
  using UniversalID::Refinements::ArrayRefinement
  using UniversalID::Refinements::HashRefinement
  using UniversalID::Refinements::SetRefinement
  using UniversalID::Refinements::OpenStructRefinement

  class CircularReferenceError < StandardError
    def initialize(message = "Prepacking not supported on self referencing objects!")
      super
    end
  end

  class << self
    def prepack(object, options = {})
      options = UniversalID::PrepackOptions.new(options) unless options.is_a?(UniversalID::PrepackOptions)
      object.instance_variable_set(:@_uid_prepack_options, options) unless object.frozen?

      return object unless object.respond_to?(:prepack)

      object.prepack options
    end
  end
end
