# frozen_string_literal: true

UniversalID::MessagePackUtils.register_type Set,
  # to_msgpack_ext
  packer: ->(set) { MessagePack.pack set.to_a },

  # from_msgpack_ext
  unpacker: ->(string) { Set.new MessagePack.unpack(string) }
