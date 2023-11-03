# frozen_string_literal: true

require "global_id"
require "active_record"

GlobalID.app = SignedGlobalID.app = "universal-id"
SignedGlobalID.verifier = GlobalID::Verifier.new("4ae705a3f0f0c675236cc7067d49123d")

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

require_relative "models/application_record"
require_relative "models/campaign"
require_relative "models/email"
