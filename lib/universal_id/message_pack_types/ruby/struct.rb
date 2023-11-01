# frozen_string_literal: true

using ::UniversalID::Refinements::Kernel

::UniversalID::MessagePackTypes.register ::Struct,
  # to_msgpack_ext
  packer: ->(struct) { ::MessagePack.pack [struct.class.name, struct.to_h] },

  # from_msgpack_ext
  unpacker: ->(string) do
    class_name, hash = ::MessagePack.unpack(string)
    klass = const_find(class_name)

    # shenanigans to support ::Ruby 3.0.X and 3.1.X
    ::RUBY_VERSION.start_with?("3.0", "3.1") ?
      klass.new.tap { |struct| hash.each { |key, val| struct[key] = hash[key] } } :
      klass.new(**hash)
  end
