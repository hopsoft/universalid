# frozen_string_literal: true

require "active_record"

class Campaign < ActiveRecord::Base
  include GlobalID::Identification
  include UniversalID::Identification

  has_many :emails
  accepts_nested_attributes_for :emails
end
