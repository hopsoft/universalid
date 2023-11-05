# frozen_string_literal: true

require_relative "refinements"
require_relative "prepack_config"

class UniversalID::Prepacker
  using ::UniversalID::Refinements::ArrayRefinement
  using ::UniversalID::Refinements::HashRefinement

  attr_reader :object

  def initialize(object)
    @object = case object
    when Array, Hash then object
    else raise ArgumentError, "Object must be a Hash or Array!"
    end
  end

  def prepack(config = nil)
    with_prepack_config(config) { object.prepack }
  end

  private

  def with_prepack_config(config = nil)
    Thread.current[:prepack_config] = UniversalID::PrepackConfig.new(config)
    yield
  ensure
    Thread.current[:prepack_config] = nil
  end
end
