# frozen_string_literal: true

require_relative "lib/runner"

name = "UniversalID::Packer pack/unpack"

description = <<~DESC
  Serializes an ActiveRecord (id only), deserializes the payload,
  then reconstructs the record from the payload.

  Benchmark:
  - dump: UniversalID::Packer.pack subject
  - load: UniversalID::Packer.unpack payload

  Control:
  - dump: Marshal.dump subject.attributes.slice("id")
  - load: subject.class.find_by id: Marshal.load(payload)["id"]

  SEE: ./bin/#{__FILE__.split("/bin/").last}
DESC

runner = Runner.new name, description,
  # control...
  dump: -> { Marshal.dump subject.attributes.slice("id") },
  load: -> { subject.class.find_by id: Marshal.load(payload)["id"] }

runner.run_dump("UniversalID::Packer.pack") { UniversalID::Packer.pack subject }
runner.run_load("UniversalID::Packer.unpack") { UniversalID::Packer.unpack payload }
