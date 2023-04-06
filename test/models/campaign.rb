# frozen_string_literal: true

require "active_record"

class Campaign < ApplicationRecord
  has_many :emails, dependent: :destroy
  accepts_nested_attributes_for :emails

  def as_json(options = {})
    super options.merge(
      except: [:id, :created_at, :updated_at],
      methods: [:emails_attributes]
    )
  end

  def emails_attributes
    emails.as_json
  end
end
