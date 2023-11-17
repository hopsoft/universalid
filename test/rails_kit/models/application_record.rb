# frozen_string_literal: true

require "model_probe"
require_relative "concerns/testable"
require_relative "../../../lib/universal_id/version"

class ApplicationRecord < ActiveRecord::Base
  extend ModelProbe
  include Testable
  include GlobalID::Identification

  VERSION = UniversalID::VERSION

  self.abstract_class = true
end
