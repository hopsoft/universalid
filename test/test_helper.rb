# frozen_string_literal: true

require "bundler"
require "pry-byebug"
require "pry-doc"
require "active_support/test_case"
require "faker"

require "minitest/reporters"
Minitest::Reporters.use!

require "globalid"
GlobalID.app = "UniversalID"
SignedGlobalID.app = "UniversalID"
SignedGlobalID.verifier = GlobalID::Verifier.new("UniversalID")

require_relative "../lib/universalid"
require_relative "./models"
