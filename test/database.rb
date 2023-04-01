ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.column :name, :string
    t.column :email, :string
    t.timestamps
  end
end
