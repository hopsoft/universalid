# frozen_string_literal: true

module UniversalID::ActiveModelSerializer
  extend ActiveSupport::Concern

  class_methods do
    def from_packable_hash(value, options = {})
      hash = if value.is_a?(UniversalID::PackableHash)
        value
      elsif UniversalID.possible_gid_string?(value)
        gid = GlobalID.parse(value, options) || SignedGlobalID.parse(value, options)
        gid&.find
      end

      attributes = hash&.values&.first

      return nil unless attributes
      return new(attributes) unless attributes[:id]

      find_by(id: attributes[:id]).tap do |rec|
        rec&.assign_attributes attributes
      end
    end
  end

  def to_packable_hash(options = {})
    UniversalID::PackableHash.new as_json(options.merge(root: true))
  end
end
