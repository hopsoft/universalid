# frozen_string_literal: true

require_relative "refinements"

class UniversalID::Prepacker
  using UniversalID::Refinements::KernelRefinement
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

      return object.prepack(options) if object.respond_to?(:prepack)

      object.instance_variable_set(:@_uid_prepack_options, options) unless object.frozen?
      object
    end
  end
end
