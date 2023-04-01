# frozen_string_literal: true

require "active_record"

class User < ActiveRecord::Base
  include GlobalID::Identification
  include UniversalID::Identification

  def self.uncommitted
    transaction do
      yield
      raise ActiveRecord::Rollback
    end
  end
end
