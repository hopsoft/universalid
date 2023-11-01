# frozen_string_literal: true

module UniversalID::ActiveRecordEncoder
  extend ActiveSupport::Concern

  class_methods do
    def from_universal_id(uid)
      UniversalID::URI::UID.parse(uid)&.decode
    end

    alias_method :from_uid, :from_universal_id
  end

  def to_universal_id(options = {})
    UniversalID::URI::UID.create self, options
  end

  alias_method :to_uid, :to_universal_id
end
