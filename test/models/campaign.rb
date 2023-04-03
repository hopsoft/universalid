# frozen_string_literal: true

require "active_record"

class Campaign < ActiveRecord::Base
  has_many :emails
  accepts_nested_attributes_for :emails
end
