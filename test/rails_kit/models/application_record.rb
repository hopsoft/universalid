# frozen_string_literal: true

require_relative "active_record_etl"
require_relative "concerns/testable"
require_relative "../../../lib/universalid/version"

class ApplicationRecord < ActiveRecord::Base
  extend ModelProbe
  include GlobalID::Identification
  include Testable

  VERSION = UniversalID::VERSION

  self.abstract_class = true

  def data_pipeline
    ActiveRecordETL.new self
  end

  delegate :extract, :transform, to: :data_pipeline
end
