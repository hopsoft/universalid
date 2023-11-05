# frozen_string_literal: true

UniversalID::MessagePackFactory.register_next_type Range,
  packer: ->(obj, packer) do
    packer.write obj.first
    packer.write obj.to_s.scan(/\.{2,3}/).first
    packer.write obj.last
  end,

  unpacker: ->(unpacker) do
    first = unpacker.read
    operator = unpacker.read
    last = unpacker.read
    case operator
    when ".." then first..last
    when "..." then first...last
    end
  end,

  recursive: true
