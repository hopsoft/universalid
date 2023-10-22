# frozen_string_literal: true

# Registers recursive support for all Objects that implement GlobalID

UniversalID::MessagePack.register_type Object,
  packer: ->(value) {
    if value.respond_to? :to_gid_param
      value.to_gid_param.b
    elsif value.respond_to? :to_msgpack_ext
      value.to_msgpack_ext
    else
      value.to_msgpack
    end
  },

  unpacker: ->(value) {
    value = value.encode("UTF-8")

    gid = if UniversalID.possible_gid_string?(value)
      GlobalID.parse(value) || SignedGlobalID.parse(value)
    end

    gid ? gid.find : MessagePack.unpack(value)
  }
