# frozen_string_literal: true

runner = Runner.new desc: <<-DESC
   Packs an ActiveRecord (id only), then unpacks the payload.

   Benchmark:
   - dump: UniversalID::Packer.pack subject
   - load: UniversalID::Packer.unpack payload

   Control:
   - dump: Marshal.dump subject.attributes.slice("id")
   - load: subject.class.find_by id: Marshal.load(payload)["id"]
DESC

# serialize (control) ........................................................................................
runner.control_dump "Marshal.dump (id only)" do
  Marshal.dump subject.attributes.slice("id")
end

# deserialize (control) ......................................................................................
runner.control_load "Marshal.load + AR find(id)" do
  subject.class.find_by id: Marshal.load(control_payload)["id"]
end

# serialize ..................................................................................................
runner.run_dump("UniversalID::Packer.pack") do
  UniversalID::Packer.pack subject
end

# deserialize ................................................................................................
runner.run_load("UniversalID::Packer.unpack") do
  UniversalID::Packer.unpack payload
end
