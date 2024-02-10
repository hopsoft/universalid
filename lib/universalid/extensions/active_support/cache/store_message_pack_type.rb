# frozen_string_literal: true

if defined? ActiveSupport::Cache::Store

  UniversalID::MessagePackFactory.register(
    type: ActiveSupport::Cache::Store,
    packer: ->(obj, packer) do
      packer.write obj.class.name
      packer.write obj.options
      packer.write obj.instance_variable_get(:@data)
    end,
    unpacker: ->(unpacker) do
      class_name = unpacker.read
      options = unpacker.read
      data = unpacker.read
      Object.const_get(class_name).new(options).tap do |store|
        store.instance_variable_set :@data, data
      end
    end
  )

end
