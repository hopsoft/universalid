# frozen_string_literal: true

require "active_record"

class Email < ActiveRecord::Base
  include GlobalID::Identification
  include UniversalID::Identification

  belongs_to :campaign
  belongs_to :previous_email, class_name: "Email", foreign_key: "previous_email_id", optional: true
  has_one :next_email, class_name: "Email", foreign_key: "previous_email_id"
end
