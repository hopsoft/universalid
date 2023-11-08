# frozen_string_literal: true

class UniversalID::ActiveRecordBaseUnpacker
  using UniversalID::Refinements::KernelRefinement

  class << self
    def unpack_with(unpacker)
      class_name = unpacker.read
      attributes = unpacker.read || {}
      create_instance class_name, attributes
    end

    private

    def create_instance(class_name, attributes)
      klass = const_find(class_name)
      return nil unless klass

      record = if attributes[klass.primary_key]
        klass.find_by(id: attributes[klass.primary_key])
      else
        klass.new
      end

      attributes.each do |key, value|
        record.public_send "#{key}=", value if record.respond_to? "#{key}="
      end

      record
    end
  end
end
