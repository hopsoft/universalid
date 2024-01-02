# frozen_string_literal: true

runner = Runner.new desc: <<-DESC
   Packs an ActiveRecord with it's loaded associations, then unpacks the payload.

   Benchmark:
   - dump: UniversalID::Packer.pack subject,
           include_descendants: true, descendant_depth: 2
   - load: UniversalID::Packer.unpack payload

   Control:
   - dump: Marshal.dump subject
   - load: Marshal.load payload
DESC

# serialize (control) ........................................................................................
runner.control_dump "Marshal.dump" do
  Marshal.dump subject
end

# deserialize (control) ......................................................................................
runner.control_load "Marshal.load" do
  Marshal.load control_payload
end

# serialize ..................................................................................................
runner.run_dump("UniversalID::Packer.pack") do
  UniversalID::Packer.pack subject, include_descendants: true, descendant_depth: 2
end

# deserialize ................................................................................................
runner.run_load("UniversalID::Packer.unpack") do
  UniversalID::Packer.unpack payload
end
