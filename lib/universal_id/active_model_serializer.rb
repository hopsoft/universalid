# frozen_string_literal: true

module UniversalID::ActiveModelSerializer
  extend ActiveSupport::Concern

  class_methods do
    def from_packable(value, options = {})
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

  def to_packable(options = {})
    UniversalID::PackableHash.new as_json(options.merge(root: true))
  end
end
