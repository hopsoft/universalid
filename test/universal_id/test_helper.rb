# frozen_string_literal: true

require "bundler"
require "pry-byebug"
require "pry-doc"
require "active_support"
require "active_support/test_case"
require "faker"
require "simplecov"

require "minitest/reporters"
Minitest::Reporters.use!

SimpleCov.start

require_relative "../../lib/universalid"
require_relative "../models"

module UniversalID::TestSuite; end

GlobalID.app = SignedGlobalID.app = UniversalID.app = "universal-id--test-suite"
SignedGlobalID.verifier = GlobalID::Verifier.new("4ae705a3f0f0c675236cc7067d49123d")
UniversalID::MessagePackUtils.register_all_types!

class ActiveSupport::TestCase
  def with_persisted_campaign
    campaign = Campaign.create!(name: Faker::Movie.title)
    yield campaign
  ensure
    campaign&.destroy
  end

  def with_new_campaign
    yield Campaign.new(name: Faker::Movie.title)
  end
end
