# frozen_string_literal: true

class UniversalID::GlobalIDIdentificationPacker
  using ::UniversalID::Refinements::Kernel
  extend Forwardable

  class << self
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
end
