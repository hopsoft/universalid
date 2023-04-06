# frozen_string_literal: true

require "active_record"

class User < ApplicationRecord
  include GlobalID::Identification

  def self.uncommitted
    transaction do
      yield
      raise ActiveRecord::Rollback
    end
  end
end
