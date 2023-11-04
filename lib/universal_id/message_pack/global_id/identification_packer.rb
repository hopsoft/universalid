# frozen_string_literal: true

class UniversalID::GlobalIDIdentificationPacker
  using ::UniversalID::Refinements::Kernel
  extend Forwardable

  class << self
    attr_writer :config

    def config
      @config ||= ::UniversalID.config.message_pack.global_id
    end
  end

  def_delegators :"self.class", :config
  attr_reader :object

  # NOTE: The object is not passed to the constructor when unpacking
  def initialize(object = nil)
    @object = object
  end

  # Packs the object using a MessagePack::Packer
  def pack_with(packer)
    packer.write object.class.name
    packer.write prepare_for_packing(object.public_send(config.prepack_method))
  end

  # Unpacks the object using a MessagePack::Unpacker
  def unpack_with(unpacker)
    class_name = unpacker.read
    hash = unpacker.read || {}
    create_instance class_name, hash
  end

  private

  # Indicates if the key should be excluded before packing
  def exclude?(key)
    @excludes ||= config.exclude.to_h { |key| [key, true] }
    @excludes[key]
  end

  # Indicates if the key should be included before packing
  def includes?(key)
    @includes ||= config.include.to_h { |key| [key, true] }
    return true if @includes[:include].empty?
    @includes[:include][key]
  end

  # Indicates if we should remove blank values before packing
  def include_blank?
    return @include_blank[:include_blank] if @include_blank
    @include_blank ||= {include_blank: !!config.include_blank}
  end

  # Indicates if we should exclude blank values before packing
  def exclude_blank?
    !include_blank?
  end

  # Prepares a hash representation of the object for packing
  def prepare_for_packing(hash = {})
    hash.each_with_object({}) do |(key, val), memo|
      key = key.to_s
      next if excludes[key]
      next if !includes.empty? && includes[key]
      next if exclude_blank? && val.nil? || val.respond_to?(:empty?) && val.empty?
      memo[key] = val.is_a?(::Hash) ? prepare_for_packing(val) : val
    end
  end

  # Attempts to create unpacked data into an object instance
  def create_instance(klass, hash = {})
    return nil unless klass
    return hash if klass == ::Hash
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
