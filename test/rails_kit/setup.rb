# frozen_string_literal: true

GlobalID.app = SignedGlobalID.app = "universal-id"
SignedGlobalID.verifier = GlobalID::Verifier.new("4ae705a3f0f0c675236cc7067d49123d")

begin
  stdout = $stdout
  $stdout = StringIO.new

  ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

  ActiveRecord::Schema.define do
    create_table :campaigns do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :trigger, :string
      t.timestamps
    end

    create_table :emails do |t|
      t.column :campaign_id, :integer
      t.column :subject, :string
      t.column :body, :text
      t.column :wait, :integer
      t.timestamps
    end

    create_table :attachments do |t|
      t.column :email_id, :integer
      t.column :file_name, :string
      t.column :content_type, :string
      t.column :file_size, :integer
      t.column :file_data, :binary
      t.timestamps
    end
  end
ensure
  $stdout = stdout
end

require_relative "models/application_record"
require_relative "models/campaign"
require_relative "models/email"
require_relative "models/attachment"

# Seed some data
10.times do
  Campaign.create_for_test do |campaign|
    5.times do
      Email.create_for_test campaign: campaign do |email|
        3.times { Attachment.create_for_test email: email }
      end
    end
  end
end
