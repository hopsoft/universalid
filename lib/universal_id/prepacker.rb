# frozen_string_literal: true

require "observer"
require_relative "refinements"

class UniversalID::Prepacker
  using UniversalID::Refinements::KernelRefinement
  using UniversalID::Refinements::ArrayRefinement
  using UniversalID::Refinements::HashRefinement
  using UniversalID::Refinements::SetRefinement
  using UniversalID::Refinements::OpenStructRefinement

  extend Observable

  class << self
    def prepack(object, options = {})
      options = UniversalID::PrepackOptions.new(options) unless options.is_a?(UniversalID::PrepackOptions)

      notify :before, object

      prepacked = if object.respond_to?(:prepack)
        object.prepack options
      else
        object.instance_variable_set(:@_uid_prepack_options, options) unless object.frozen?
        object
      end

      notify :after, object, prepacked

      prepacked
    end

    def notify_object(event, object, prepacked = nil)
      method_name = "#{event}_prepack"
      object.public_send method_name, object, prepacked if object.respond_to?(method_name)
    end

    private

    def notify(event, *args)
      changed
      notify_observers event, *args
    end
  end

  add_observer self, :notify_object

  class CircularReferenceError < StandardError
    def initialize(message = "Prepacking not supported on self referencing objects!")
      super
    end
  end
end
