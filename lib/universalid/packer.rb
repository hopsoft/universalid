# frozen_string_literal: true

class UniversalID::Packer
  class << self
    def pack(object, options = {})
      object = UniversalID::Prepacker.prepack(object, options)

      # This is basically the same call as UniversalID::MessagePackFactory.pack(object),
      # but it uses a pool of pre-initialized packers/unpackers instead of creating a new one each time
      UniversalID::MessagePackFactory.msgpack_pool.dump object
    end

    def unpack(string)
      # This is basically the same call as UniversalID::MessagePackFactory.unpack(object),
      # but it uses a pool of pre-initialized packers/unpackers instead of creating a new one each time
      UniversalID::MessagePackFactory.msgpack_pool.load string
    end
  end
end
