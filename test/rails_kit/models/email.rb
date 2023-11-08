# frozen_string_literal: true

class Email < ApplicationRecord
  belongs_to :campaign
  has_many :email_attachments, dependent: :destroy
end
