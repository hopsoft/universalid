# frozen_string_literal: true

module UniversalID::ActiveRecordEncoder
  def self.included(subclass)
    subclass.extend ClassMethods
    subclass.include InstanceMethods
  end

  module ClassMethods
    def from_universal_id(uid)
      URI::UID.parse(uid)&.decode
    end

    alias_method :from_uid, :from_universal_id
  end

  module InstanceMethods
    def to_universal_id
      URI::UID.create self
    end

    alias_method :to_uid, :to_universal_id
  end
end
