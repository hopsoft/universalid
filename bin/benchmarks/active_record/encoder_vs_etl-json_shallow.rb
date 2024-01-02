# frozen_string_literal: true

runner = Runner.new desc: <<-DESC
   Encodes an ActiveRecord (id only), then decodes the payload.

   Benchmark:
   - serialize: UniversalID::Encoder.encode subject
   - deserialize: UniversalID::Encoder.decode payload

   Control:
   - dump: ActiveRecordETL::Pipeline.new(subject).transform only: ["id"]
   - load: subject.class.find_by id: ActiveRecordETL.parse(payload)["id"]
DESC

# serialize (control) ........................................................................................
runner.control_dump "ActiveRecordETL::Pipeline#tranform (id only)" do
  subject.transform only: ["id"]
end

# deserialize (control) ......................................................................................
runner.control_load "ActiveRecordETL.parse + AR find(id)" do
  subject.class.find_by id: ActiveRecordETL.parse(payload)["id"]
end

# serialize ..................................................................................................
runner.run_dump("UniversalID::Packer.pack") do
  UniversalID::Encoder.encode subject
end

# deserialize ................................................................................................
runner.run_load("UniversalID::Packer.unpack") do
  UniversalID::Encoder.decode payload
end
