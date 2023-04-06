# frozen_string_literal: true

require "active_record"

class Email < ApplicationRecord
  include UniversalID::ActiveModelSerializer

  belongs_to :campaign

  def as_json(options = {})
    super options.merge(
      except: [:id, :campaign_id, :created_at, :updated_at]
    )
  end
end
