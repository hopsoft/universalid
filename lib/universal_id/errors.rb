# frozen_string_literal: true

class UniversalID::LocatorError < StandardError
  attr_reader :id, :cause

  def initialize(id = nil, cause = nil)
    super "Failed to locate the id #{id.inspect} Cause: #{cause.inspect}"
    @id = id
    @cause = cause
  end
end
