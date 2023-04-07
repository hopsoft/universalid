# frozen_string_literal: true

class UniversalID::PortableVersion
  include GlobalID::Identification

  DELIMITER = "@"

  class << self
    def find(id)
      scope, version_string = id.split(DELIMITER)
      new(version_string, scope: scope)
    end
  end

  attr_reader :version, :scope

  def initialize(version_string, scope: "default")
    @version = version_string.to_s.split(".").map(&:to_i)
    @scope = scope.to_s.parameterize
  end

  def id
    "#{scope}#{DELIMITER}#{version.join(".")}"
  end

  alias_method :to_s, :id
end
