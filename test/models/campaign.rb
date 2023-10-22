# frozen_string_literal: true

require "active_record"

class Campaign < ApplicationRecord
  has_many :emails, dependent: :destroy
  accepts_nested_attributes_for :emails
end
