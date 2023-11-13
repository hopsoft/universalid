# frozen_string_literal: true

class Campaign < ApplicationRecord
  has_many :emails, dependent: :destroy
end
