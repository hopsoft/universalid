# frozen_string_literal: true

class Email < ApplicationRecord
  belongs_to :campaign
  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments
end
