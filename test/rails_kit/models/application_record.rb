# frozen_string_literal: true

require_relative "active_record_etl"
require_relative "active_record_forge"
require_relative "../../../lib/universalid/version"

class ApplicationRecord < ActiveRecord::Base
  extend ModelProbe

  include ActiveRecordETL
  include ActiveRecordForge
  include GlobalID::Identification

  VERSION = UniversalID::VERSION

  self.abstract_class = true
end
