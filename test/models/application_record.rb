# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include GlobalID::Identification
  include UniversalID::ActiveModelSerializer
  self.abstract_class = true
end
