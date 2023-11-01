# frozen_string_literal: true

UniversalID::MessagePackTypes.register Set,
  # to_msgpack_ext
  packer: ->(set) { MessagePack.pack set.to_a },

  # from_msgpack_ext
  unpacker: ->(string) { Set.new MessagePack.unpack(string) }
