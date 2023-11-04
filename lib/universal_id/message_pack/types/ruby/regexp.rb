# frozen_string_literal: true

::UniversalID::MessagePackFactory.register_next_type ::Regexp,
  packer: ->(obj, packer) do
    packer.write obj.source
    packer.write obj.options
  end,
  unpacker: ->(unpacker) do
    source = unpacker.read
    options = unpacker.read
    ::Regexp.new source, options
  end,
  recursive: true
