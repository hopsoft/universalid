# frozen_string_literal: true

require "bundler"
require "pry-byebug"
require "pry-doc"
require "active_support/test_case"
require "faker"

require "minitest/reporters"
Minitest::Reporters.use!

require "globalid"
GlobalID.app = "test.universalid"
SignedGlobalID.app = "test.universalid"
SignedGlobalID.verifier = GlobalID::Verifier.new("test.universalid")

require_relative "../lib/universalid"
require_relative "./database"
