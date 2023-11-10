# frozen_string_literal: true

using UniversalID::Refinements::KernelRefinement

UniversalID::MessagePackFactory.register(
  type: Struct,
  recreate_pool: false,
  packer: ->(obj, packer) do
    packer.write obj.class.name
    packer.write obj.to_h
  end,

  unpacker: ->(unpacker) do
    class_name = unpacker.read
    hash = unpacker.read
    klass = const_find(class_name)

    # shenanigans to support ::Ruby 3.0.X and 3.1.X
    RUBY_VERSION.start_with?("3.0", "3.1") ?
      klass.new.tap { |struct| hash.each { |key, val| struct[key] = hash[key] } } :
      klass.new(**hash)
  end
)
