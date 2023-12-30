# frozen_string_literal: true

runner = Runner.new "bin/#{__FILE__.split("/bin/").last}", <<-DESC
   Serializes an ActiveRecord (id only), deserializes the payload,
   then reconstructs the record.

   Benchmark:
   - dump: UniversalID::Packer.pack subject
   - load: UniversalID::Packer.unpack payload

   Control:
   - dump: ActiveRecordETL.new(subject).transform only: ["id"]
   - load: subject.class.find_by id: ActiveRecordETL.parse(payload)["id"]
DESC

# serialize (control) ........................................................................................
runner.control_dump "ActiveRecordETL#tranform (id only)" do
  ActiveRecordETL.new(subject).transform only: ["id"]
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
