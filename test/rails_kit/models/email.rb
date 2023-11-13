# frozen_string_literal: true

class Email < ApplicationRecord
  belongs_to :campaign
  has_many :attachments, dependent: :destroy
end
