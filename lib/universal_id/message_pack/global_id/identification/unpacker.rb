# frozen_string_literal: true

class UniversalID::GlobalIDIdentificationUnpacker
  using ::UniversalID::Refinements::KernelRefinement

  class << self
    # Unpacks the object using a MessagePack::Unpacker
    def unpack_with(unpacker)
      class_name = unpacker.read
      hash = unpacker.read || {}
      create_instance class_name, hash
    end

    private

    # Attempts to create unpacked data into an object instance
    def create_instance(class_name, hash = {})
      return hash if klass == ::Hash

      klass = const_find(class_name)
      return nil unless klass

      (klass.instance_method(:initialize).arity > 0) ?
        create_instance_with_initializer(klass, hash) :
        create_instance_with_setters(klass, hash)
    end

    # Attempts to reconstruct unpacked data into an object via initializer (falls back to setters on error)
    def create_instance_with_initializer(klass, hash = {})
      klass.new hash
    rescue
      begin
        create_instance_with_setters(klass, **hash)
      rescue ArgumentError
        create_instance_with_setters klass, hash
      end
    end

    # Attempts to reconstruct unpacked data into an object via setters
    def create_instance_with_setters(klass, hash = {})
      klass.new.tap do |o|
        hash.each { |key, val| o.public_send "#{key}=", val if o.respond_to?("#{key}=") }
      end
    end
  end
end
