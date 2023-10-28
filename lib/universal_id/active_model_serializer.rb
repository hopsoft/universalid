# frozen_string_literal: true

module UniversalID::ActiveModelSerializer
  extend ActiveSupport::Concern

  class_methods do
    # Converts a UniversalID::MarshalableHash to an ActiveRecord
    #
    # @param value [UniversalID::Packable, GlobalID, SignedGlobalID, String] the packable value to be converted
    # @param options [Hash] options for the GlobalID or SignedGlobalID parse method
    #                       ignored if the id is not a GlobalID or SignedGlobalID string
    # @return [Object, nil] an ActiveRecord instance or nil
    # @raise [UniversalID::LocatorError] if the packable value cannot be found
    def from_packable(value, options = {})
      hash = UniversalID::MarshalableHash.find(value, options)
      keys = hash&.keys || []
      values = hash&.values || []

      model = keys&.first&.classify&.safe_constantize
      attributes = values&.first

      return nil unless model && attributes
      return model.new(attributes) unless attributes[:id]

      model.find_by(id: attributes[:id]).tap do |record|
        record&.assign_attributes attributes.except(:id)
      end
    end
  end

  # Converts an ActiveRecord to a UniversalID::MarshalableHash
  #
  # @param options [Hash] (default: {}) options to pass to the `as_json` method
  # @return [UniversalID::MarshalableHash]
  def to_packable(options = {})
    UniversalID::MarshalableHash.new as_json(options.merge(root: true))
  end
end
