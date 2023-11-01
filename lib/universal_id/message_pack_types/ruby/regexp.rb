# frozen_string_literal: true

UniversalID::MessagePackTypes.register Regexp,
  # to_msgpack_ext
  packer: ->(regexp) {
    MessagePack.pack [
      regexp.source, # pattern
      regexp.options # options
    ]
  },

  # from_msgpack_ext
  unpacker: ->(string) { Regexp.new(*MessagePack.unpack(string)) }
