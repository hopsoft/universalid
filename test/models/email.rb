# frozen_string_literal: true

require "active_record"

class Email < ActiveRecord::Base
  belongs_to :campaign
end
