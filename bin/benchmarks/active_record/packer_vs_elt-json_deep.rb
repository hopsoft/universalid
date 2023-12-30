# frozen_string_literal: true

runner = Runner.new "bin/#{__FILE__.split("/bin/").last}", <<-DESC
   Serializes an ActiveRecord with it's loaded associations,
   deserializes the payload, then reconstructs the record with associations.

   Benchmark:
   - dump: UniversalID::Packer.pack subject,
           include_descendants: true, descendant_depth: 2
   - load: UniversalID::Packer.unpack payload

   Control:
   - dump: ActiveRecordETL.new(subject).transform nested_attributes: true
   - load: (apples -vs- oranges)
       UID implicitly does a lot under the hood
       I approximate that behavior for control load
       See the benchmark file for details
DESC

# serialize (control) ........................................................................................
runner.control_dump "ActiveRecordETL#tranform" do
  ActiveRecordETL.new(subject).transform nested_attributes: true
end

# deserialize (control) ......................................................................................
runner.control_load "ActiveRecordETL.parse + AR find(id)" do
  parsed = ActiveRecordETL.parse(payload)
  campaign = subject.class.find_by(id: parsed["id"])
  campaign.assign_attributes parsed.except("id", "emails_attributes")
  campaign.emails.load
  parsed["emails_attributes"].each do |email_attributes|
    email = campaign.emails.find { |e| e.id == email_attributes["id"] }
    email.assign_attributes email_attributes.except("id", "attachments_attributes")
    email.attachments.load
    email_attributes["attachments_attributes"].each do |attachment_attributes|
      attachment = email.attachments.find { |a| a.id == attachment_attributes["id"] }
      attachment.assign_attributes attachment_attributes.except("id")
    end
  end
  campaign
end

# serialize ..................................................................................................
runner.run_dump("UniversalID::Packer.pack") do
  UniversalID::Packer.pack subject, include_descendants: true, descendant_depth: 2
end

# deserialize ................................................................................................
runner.run_load("UniversalID::Packer.unpack") do
  UniversalID::Packer.unpack payload
end
