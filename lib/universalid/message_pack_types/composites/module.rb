# frozen_string_literal: true

UniversalID::MessagePackFactory.register(
  type: Module,
  recreate_pool: false,
  packer: ->(obj, packer) { packer.write obj.name },
  unpacker: ->(unpacker) do
    name = unpacker.read
    Object.const_defined?(name) ? Object.const_get(name) : nil
  end
)
