# frozen_string_literal: true

require "active_record"

class Email < ApplicationRecord
  belongs_to :campaign
end
