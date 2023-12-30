# frozen_string_literal: true

class Campaign < ApplicationRecord
  has_many :emails, dependent: :destroy
  accepts_nested_attributes_for :emails
end

class Example < ApplicationRecord
  attribute :marked_for_destruction, :boolean, default: false

  def initialize(...)
    super(...)
    @marked_for_destruction = !!attributes["marked_for_destruction"]
  end

  def mark_for_destruction
    super
    @marked_for_destruction = true
  end
end
