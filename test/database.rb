# frozen_string_literal: true

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.column :name, :string
    t.column :email, :string
    t.timestamps
  end

  create_table :campaigns do |t|
    t.column :name, :string
    t.column :description, :string
    t.column :trigger, :string
    t.column :wait, :integer
    t.timestamps
  end

  create_table :emails do |t|
    t.column :campaign_id, :integer
    t.column :previous_email_id, :integer
    t.column :subject, :string
    t.column :body, :text
    t.timestamps
  end
end

require_relative "../test/models/campaign"
require_relative "../test/models/email"
require_relative "../test/models/user"
