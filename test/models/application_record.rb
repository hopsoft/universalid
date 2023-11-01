# frozen_string_literal: true

require "model_probe"

class ApplicationRecord < ActiveRecord::Base
  extend ModelProbe
  include GlobalID::Identification
  include UniversalID::ActiveRecordEncoder
  self.abstract_class = true
end
