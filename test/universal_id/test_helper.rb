# frozen_string_literal: true

require "bundler"
require "faker"
require "minitest/autorun"
require "pry-byebug"
require "pry-doc"
require "simplecov"

require "minitest/reporters"
Minitest::Reporters.use!

SimpleCov.start

# GlobalID must be loaded before UniversalID to use GID supported features of UID
require "global_id"
require_relative "../../lib/universal_id"

# Bring in a minimal subset of Rails tooling for testing purposes
# - GlobalID
# - ActiveRecord
require_relative "../rails_parts"

UniversalID::MessagePackTypes.register_all

class Minitest::Test
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
