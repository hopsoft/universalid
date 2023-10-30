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

GlobalID.app = SignedGlobalID.app = UniversalID.app = "uid-test"
SignedGlobalID.verifier = GlobalID::Verifier.new("4ae705a3f0f0c675236cc7067d49123d")
