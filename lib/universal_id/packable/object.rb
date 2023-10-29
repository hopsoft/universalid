# frozen_string_literal: true

require_relative "../marshal"
require_relative "../uri/uid"
require_relative "../global_id_object"

class UniversalID::Packable::Object
  class << self
    # Unpacks a value into a UniversalID::Packable instance
    #
    # @param options [Hash] options for the GlobalID or SignedGlobalID parse method
    #                       ignored if the value is not a GlobalID or SignedGlobalID string
    # @param value [UniversalID::Packable, UniversalID::UID, URI::GID, GlobalID, SignedGlobalID, String] the value to unpack
    # @return [UniversalID::Packable, nil] a UniversalID::Packable or nil
    def unpack(value, **options)
      case value
      when UniversalID::Packable::Object then value
      when UniversalID::URI::UID then value.packable_class.unpack(value.packed) if value.unpackable?
      when GlobalID, SignedGlobalID then unpack(value.find)
      when URI::GID then unpack(value.to_s, options)
      when String
        return unpack(UniversalID::URI::UID.parse(value)) if UniversalID::URI::UID.match?(value.to_s)

        gid = GlobalID.parse(value) || SignedGlobalID.parse(value, options)
        return unpack(gid) if gid

        unpacked ||= begin
          UniversalID::Marshal.load(value)
        rescue
          # TODO: ??? returning nil is fine but should we attempt to log?
        end

        unpacked ? new(unpacked) : nil
      end
    end
  end

  attr_reader :object

  def initialize(object = Object.new)
    @object = object
  end

  # Packs the Object into a compact URL safe String
  #
  # @param options [Hash] packing options (ignored, but can be overridden by subclasses)
  # @return [String] the packed value
  def pack(**options)
    UniversalID::Marshal.dump object
  end

  def to_uri(**options)
    UniversalID::URI::UID.create(self, **options)
  end

  alias_method :to_uid, :to_uri

  def to_global_id_object(**options)
    UniversalID::Packable::GlobalIDObject.new to_uid(**options).to_s
  end

  alias_method :to_gid_object, :to_global_id_object
end
