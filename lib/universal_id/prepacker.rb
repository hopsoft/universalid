# frozen_string_literal: true

require_relative "refinements"
require_relative "active_record_prepack_primer"

class UniversalID::Prepacker
  using UniversalID::Refinements::ArrayRefinement
  using UniversalID::Refinements::HashRefinement
  using UniversalID::Refinements::SetRefinement
  using UniversalID::Refinements::OpenStructRefinement

  MESSAGE_PACK_KEY = Digest::SHA1.hexdigest(name)[0, 8]

  class << self
    def prepack(object, options = {})
      options = UniversalID::PrepackOptions.new(options)
      object = UniversalID::ActiveRecordPrepackPrimer.new(object, options.database_options).to_h if active_record?(object)
      raise ArgumentError, "#{object.class} does not respond to `prepack`!" unless prepackable?(object)
      object.prepack options
    end

    private

    def prepackable?(object)
      object.respond_to? :prepack
    end

    def active_record?(object)
      return false unless defined?(ActiveRecord::Base)
      object.is_a? ActiveRecord::Base
    end
  end

  class CircularReferenceError < StandardError
    def initialize(message = "Prepacking not supported on self referencing objects!")
      super
    end
  end
end
