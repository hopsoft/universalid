# frozen_string_literal: true

module UniversalID::ActiveModelSerializer
  extend ActiveSupport::Concern

  class_methods do
    # Converts a UniversalID::PackableHash to an ActiveRecord
    #
    # @param value [UniversalID::Packable, GlobalID, SignedGlobalID, String] the packable value to be converted
    # @return [Object, nil] an ActiveRecord instance or nil
    # @raise [UniversalID::LocatorError] if the packable value cannot be found
    def from_packable(value, ...)
      hash = UniversalID::PackableHash.find(value)
      model = hash&.keys&.first&.classify&.safe_constantize
      attributes = hash&.values&.first

      return nil unless model && attributes
      return model.new(attributes) unless attributes[:id]

      model.find_by(id: attributes[:id]).tap do |record|
        record&.assign_attributes attributes.except(:id)
      end
    end
  end

  # Converts an ActiveRecord to a UniversalID::PackableHash
  #
  # @param options [Hash] (default: {}) options to pass to the as_json method
  # @return [UniversalID::PackableHash]
  def to_packable(options = {})
    UniversalID::PackableHash.new as_json(options.merge(root: true))
  end
end
