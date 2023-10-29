# frozen_string_literal: true

module UniversalID::Packable
  extend ActiveSupport::Concern

  UID_REGEX = /\Auid:\/\/.+\z/
  GID_REGEX = /\Agid:\/\/.+\z/
  GID_PARAM_REGEX = /\A[0-9a-zA-Z_+-\/]{20,}={0,2}.*\z/

  class_methods do
    # Unpacks a value into a UniversalID::Packable instance
    #
    # @param value [UniversalID::Packable, UniversalID::UID, URI::GID, GlobalID, SignedGlobalID, String] the value to unpack
    # @param options [Hash] options for the GlobalID or SignedGlobalID parse method
    #                       ignored if the value is not a GlobalID or SignedGlobalID string
    # @return [UniversalID::Packable, nil] a UniversalID::Packable or nil
    def unpack(value, options = {})
      case value
      when ->(v) { v.blank? } then nil
      when UniversalID::Packable then value
      when UniversalID::URI::UID then value.packable_class.unpack(value.payload) if value.unpackable?
      when GlobalID then unpack(GlobalID.parse(value, options)&.find, options)
      when SignedGlobalID then unpack(SignedGlobalID.parse(value, options)&.find, options)
      when URI::GID then unpack(value.to_s, options)
      when String
        return unpack(UniversalID::UID.parse(value)) if GID_REGEX.match?(value.to_s)
        return unpack(GlobalID.parse(value) || SignedGlobalID.parse(value, options)) if GID_REGEX.match?(value.to_s)

        gid = GlobalID.parse(value) || SignedGlobalID.parse(value, options)
        return unpack(gid) if gid

        unpacked = UniversalID::Marshal.load(value)
        unpacked ? new(unpacked) : nil
      end
    end
  end

  included do
    attr_reader :object

    def initialize(object = Object.new)
      @object = object
    end
  end

  # Packs the Object into a compact URL safe String
  #
  # @param options [Hash] packing options (ignored, but can be overridden by subclasses)
  # @return [String] the packed value
  def pack(options = {})
    UniversalID::Marshal.dump object
  end

  def to_uri(pack_options = {})
    UniversalID::URI::UID.create self, pack_options: pack_options
  end
end
