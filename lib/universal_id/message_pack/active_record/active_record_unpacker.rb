# frozen_string_literal: true

class UniversalID::ActiveRecordUnpacker
  using ::UniversalID::Refinements::Kernel

  class << self
    # Unpacks the record using a MessagePack::Unpacker
    def unpack_with(unpacker)
      class_name = unpacker.read
      attributes = unpacker.read || {}
      create_instance class_name, attributes
    end

    private

    def create_instance(class_name, attributes)
      klass = const_find(class_name)
      return nil unless klass

      if attributes.key? "id"
        klass.find_by(id: attributes["id"])
      else
        klass.new(attributes)
      end
    end
  end
end
