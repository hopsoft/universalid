# frozen_string_literal: true

require_relative "packable_rigger"
require_relative "global_id_object"

class UniversalID::PackableBase
  def self.unpack(...)
    UniversalID::PackableRigger.unpack(...)
  end

  attr_reader :object

  def initialize(object = Object.new)
    @object = object
  end

  def pack(options = {})
    UniversalID::PackableRigger.pack object
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
