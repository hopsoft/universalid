# frozen_string_literal: true

runner = Runner.new desc: <<-DESC
   Packs an ActiveRecord (id only), then unpacks the payload.

   Benchmark:
   - dump: UniversalID::Packer.pack subject
   - load: UniversalID::Packer.unpack payload

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
  UniversalID::Packer.pack subject
end

# deserialize ................................................................................................
runner.run_load("UniversalID::Packer.unpack") do
  UniversalID::Packer.unpack payload
end
