# frozen_string_literal: true

module UniversalID::ActiveModelSerializer
  extend ActiveSupport::Concern

  class_methods do
    # Attempts to find or reconstruct a record from the given value.
    #
    # Supports the following values:
    # - UniversalID::PackableHash
    # - A UniversalID::PackableHash id
    # - A GlobalID or SignedGlobalID from a UniversalID::PackableHash
    #
    # Returns nil if the record cannot be found or reconstructed.
    def from_packable_hash(value, options = {})
      hash = if value.is_a?(UniversalID::PackableHash)
        value
      elsif UniversalID.possible_gid_string?(value)
        gid = GlobalID.parse(value, options) || SignedGlobalID.parse(value, options)
        gid&.find
      end
      hash ||= UniversalID::PackableHash.find(value)

      model = hash&.keys&.first&.classify&.safe_constantize
      attributes = hash&.values&.first
      return nil unless model && attributes

      return model.new(attributes) unless attributes[:id]

      model.find_by(id: attributes[:id]).tap do |record|
        record&.assign_attributes attributes.except(:id)
      end
    end
  end

  def to_packable_hash(options = {})
    UniversalID::PackableHash.new as_json(options.merge(root: true))
  end
end
