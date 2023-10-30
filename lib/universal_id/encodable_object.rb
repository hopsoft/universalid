# frozen_string_literal: true

require_relative "encoder"
require_relative "global_id_object"

class UniversalID::EncodableObject
  def self.decode(object, options = {})
    decoded = Base64.urlsafe_decode64(value)
    inflated = Zlib::Inflate.inflate(decoded)
    MessagePack.unpack inflated
  end

  attr_reader :object

  def initialize(object = Object.new)
    @object = object
  end

  def encode(options = {})
  end

  def to_uri(options = {})
    UniversalID::URI::UID.create(self, options)
  end

  alias_method :to_uid, :to_uri

  def to_global_id_object(options = {})
    UniversalID::Packable::GlobalIDObject.new to_uid(options)
  end

  alias_method :to_gid_object, :to_global_id_object
end
