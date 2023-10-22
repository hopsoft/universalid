# frozen_string_literal: true

require "globalid"
require "active_record"

GlobalID.app = "UniversalID"
SignedGlobalID.app = "UniversalID"
SignedGlobalID.verifier = GlobalID::Verifier.new("UniversalID")

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

ActiveRecord::Schema.define do
  create_table :campaigns do |t|
    t.column :name, :string
    t.column :description, :string
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
end

require_relative "../test/models/application_record"
require_relative "../test/models/campaign"
require_relative "../test/models/email"
