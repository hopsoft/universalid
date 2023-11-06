# frozen_string_literal: true

require_relative "refinements"
require_relative "prepack_options"

class UniversalID::Prepacker
  using UniversalID::Refinements::ArrayRefinement
  using UniversalID::Refinements::HashRefinement
  using UniversalID::Refinements::SetRefinement
  using UniversalID::Refinements::OpenStructRefinement

  class << self
    def prepack(object, options = UniversalID::Configs.default.prepack)
      unless object.respond_to?(:prepack)
        raise ArgumentError, "#{object.class} does not respond to `prepack`!"
      end
      object.prepack UniversalID::PrepackOptions.new(options)
    end
  end
end
