# frozen_string_literal: true

require_relative "lib/runner"

name = "UniversalID::Packer pack/unpack"

description = <<~DESC
  Serializes an ActiveRecord with it's loaded associations,
  deserializes the payload, then reconstructs the record with associations.

  Benchmark:
  - dump: UniversalID::Packer.pack subject,
          include_descendants: true, descendant_depth: 2
  - load: UniversalID::Packer.unpack payload

  Control:
  - dump: Marshal.dump subject
  - load: Marshal.load payload

  SEE: ./bin/#{__FILE__.split("/bin/").last}
DESC

runner = Runner.new name, description,
  # control...
  dump: -> { Marshal.dump subject },
  load: -> { Marshal.load payload }

runner.run_dump("UniversalID::Packer.pack") do
  UniversalID::Packer.pack subject, include_descendants: true, descendant_depth: 2
end

runner.run_load("UniversalID::Packer.unpack") { UniversalID::Packer.unpack payload }
