# frozen_string_literal: true

::UniversalID::MessagePackTypes.register ::Range,
  # to_msgpack_ext
  packer: ->(range) { ::MessagePack.dump [range.first, range.to_s.scan(/\.{2,3}/).first, range.last] },

  # from_msgpack_ext
  unpacker: ->(string) do
    first, operator, last = ::MessagePack.unpack(string)
    case operator
    when ".." then first..last
    when "..." then first...last
    end
  end
