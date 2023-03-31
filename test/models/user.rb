# frozen_string_literal: true

require "active_record"

class User < ActiveRecord::Base
  include GlobalID::Identification
  include UniversalID::Identification
end
