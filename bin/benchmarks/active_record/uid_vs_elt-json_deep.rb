# frozen_string_literal: true

runner = Runner.new desc: <<-DESC
   Builds a UID for an ActiveRecord  with it's loaded associations,
   then parses the UID and decodes the payload.

   Benchmark:
   - serialize: URI::UID.build(subject, include_descendants: true, descendant_depth: 2).to_s
   - deserialize: URI::UID.parse(payload).decode

   Control:
   - dump: ActiveRecordETL::Pipeline.new(subject).transform nested_attributes: true
   - load: (apples -vs- oranges)
       UID implicitly does a lot under the hood
       I approximate that behavior for control load
       See the benchmark file for details
DESC

# serialize (control) ........................................................................................
runner.control_dump "ActiveRecordETL::Pipeline#tranform" do
  subject.transform nested_attributes: true
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
  URI::UID.build(subject, include_descendants: true, descendant_depth: 2).to_s
end

# deserialize ................................................................................................
runner.run_load("UniversalID::Packer.unpack") do
  URI::UID.parse(payload).decode
end
