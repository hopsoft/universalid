# frozen_string_literal: true

UniversalID::MessagePackUtils.register_type Regexp,
  # to_msgpack_ext
  packer: ->(regexp) {
    MessagePack.pack [
      regexp.source.b, # pattern
      regexp.options   # options
    ]
  },

  # from_msgpack_ext
  unpacker: ->(string) { Regexp.new(*MessagePack.unpack(string)) }
