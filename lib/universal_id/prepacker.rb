# frozen_string_literal: true

require_relative "refinements"

class UniversalID::Prepacker
  using UniversalID::Refinements::KernelRefinement
  using UniversalID::Refinements::ArrayRefinement
  using UniversalID::Refinements::HashRefinement
  using UniversalID::Refinements::SetRefinement
  using UniversalID::Refinements::OpenStructRefinement

  ID = "YFDzLF" # DO NOT CHANGE THIS VALUE!

  class << self
    def register(prepacker)
      @prepackers ||= []
      @prepackers << [prepacker.id, prepacker] if prepacker.target
    end

    def prepack(object, options = {})
      options = UniversalID::PrepackOptions.new(options)

      # find a prepacker for the object (it's most likely the object itself)
      match = @prepackers.find { |(_id, prepacker)| object.is_a? prepacker.target }
      prepacker = match&.last&.new(object) || object

      # guard before continuing
      unless prepacker.respond_to?(:prepack)
        raise ArgumentError, "#{prepacker.class} does not respond to `prepack`!"
      end

      # prepacker is the object itself
      return prepacker.prepack(options) if prepacker == object

      # using a specialized prepacker, so we wrap the result
      [ID, prepacker.class.const_get(:ID), prepacker.prepack(options)]
    end

    def restore(object)
      return object unless object.is_a?(Array)
      return object unless object.first == ID

      # prepacked with a specialized prepacker
      # attempt to unwrap the result and restore it with the specialized prepacker
      match = @prepackers.find { |(id, _)| id == object[1] }
      match&.last&.restore(object[2]) || object
    end
  end

  class CircularReferenceError < StandardError
    def initialize(message = "Prepacking not supported on self referencing objects!")
      super
    end
  end
end
