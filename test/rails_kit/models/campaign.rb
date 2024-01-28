# frozen_string_literal: true

class Campaign < ApplicationRecord
  has_many :emails, dependent: :destroy
  accepts_nested_attributes_for :emails

  scope :email_subjects_like, ->(value) do
    where id: Email.subject_like(value).select(:campaign_id)
  end
end
