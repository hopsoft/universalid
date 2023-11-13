# frozen_string_literal: true

require "model_probe"
require_relative "concerns/testable"

class ApplicationRecord < ActiveRecord::Base
  extend ModelProbe
  include Testable
  include GlobalID::Identification

  self.abstract_class = true
end
