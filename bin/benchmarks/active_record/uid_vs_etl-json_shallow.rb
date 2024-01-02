# frozen_string_literal: true

runner = Runner.new desc: <<-DESC
   Builds a UID for an ActiveRecord (id only), then parses the UID and decodes the payload.

   Benchmark:
   - serialize: URI::UID.build(subject).to_s
   - deserialize: URI::UID.parse(payload).decode

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
  URI::UID.build(subject).to_s
end

# deserialize ................................................................................................
runner.run_load("UniversalID::Packer.unpack") do
  URI::UID.parse(payload).decode
end
