# frozen_string_literal: true

require "bundler"
require "pry-byebug"
require "pry-doc"
require "active_support/test_case"
require "faker"

require "minitest/reporters"
Minitest::Reporters.use!

require_relative "../lib/universalid"
