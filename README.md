<p align="center">
  <h1 align="center">Universal ID</h1>
  <p align="center">
    <a href="http://blog.codinghorror.com/the-best-code-is-no-code-at-all/">
      <img alt="Lines of Code" src="https://img.shields.io/badge/loc-692-47d299.svg" />
    </a>
    <a href="https://codeclimate.com/github/hopsoft/universalid/maintainability">
      <img src="https://api.codeclimate.com/v1/badges/567624cbe733fafc2330/maintainability" />
    </a>
    <a href="https://rubygems.org/gems/universalid">
      <img alt="GEM Version" src="https://img.shields.io/gem/v/universalid?color=168AFE&include_prereleases&logo=ruby&logoColor=FE1616">
    </a>
    <a href="https://rubygems.org/gems/universalid">
      <img alt="GEM Downloads" src="https://img.shields.io/gem/dt/universalid?color=168AFE&logo=ruby&logoColor=FE1616">
    </a>
    <a href="https://github.com/testdouble/standard">
      <img alt="Ruby Style" src="https://img.shields.io/badge/style-standard-168AFE?logo=ruby&logoColor=FE1616" />
    </a>
    <a href="https://gitpod.io/#https://github.com/hopsoft/universalid">
      <img alt="Gitpod - Ready to Code" src="https://img.shields.io/badge/Gitpod-Ready--to--Code-green?style=flat&logo=gitpod&logoColor=white" />
    </a>
    <a href="https://github.com/hopsoft/universalid/actions/workflows/tests.yml">
      <img alt="Tests" src="https://github.com/hopsoft/universalid/actions/workflows/tests.yml/badge.svg" />
    </a>
    <a href="https://github.com/sponsors/hopsoft">
      <img alt="Sponsors" src="https://img.shields.io/github/sponsors/hopsoft?color=eb4aaa&logo=GitHub%20Sponsors" />
    </a>
    <br>
    <a href="https://ruby.social/@hopsoft">
      <img alt="Ruby.Social Follow" src="https://img.shields.io/mastodon/follow/000008274?domain=https%3A%2F%2Fruby.social&label=%40hopsoft&style=social">
    </a>
    <a href="https://twitter.com/hopsoft">
      <img alt="Twitter Follow" src="https://img.shields.io/twitter/url?label=%40hopsoft&style=social&url=https%3A%2F%2Ftwitter.com%2Fhopsoft">
    </a>
  </p>
  <h2 align="center">URL-Safe Portability for Ruby Objects</h2>
</p>

**Universal ID introduces a paradigm shift in Ruby development with powerful recursive serialization.**
This innovative library transforms any Ruby object into a URL-safe string, enabling efficient encoding and seamless data transfer across process boundaries. By simplifying complex serialization tasks, Universal ID enhances both the developer and end-user experience, paving the way for a wide range of use cases—from state preservation in web apps to inter-service communication.

It leverages both [MessagePack](https://msgpack.org/) and [Brotli](https://github.com/google/brotli) _(a combo built for speed and best-in-class data compression)_.
MessagePack + Brotli is up to 30% faster and within 2-5% compression rates compared to Protobuf. <a title="Source" href="https://g.co/bard/share/e5bdb17aee91">↗</a>

## Example Use Cases

- **State Preservation in Web Apps**: Maintain the state of a user's session in web applications without storing data server-side
- **API Data Transfer**: Serialize complex data structures into a URI format for easy and efficient transfer via RESTful APIs
- **Bookmarkable Configurations**: Allow users to bookmark configurations of a web application by embedding the state in the URL
- **Deep Linking in Web Apps**: Create deep links that carry complex state information, allowing users to return to a specific state within an application
- **Debugging Tools**: Serialize objects and their state for logging purposes, aiding in debugging and error tracking
- **Shareable Reports and Views**: Encode the state of reports or customized views in web applications, making them shareable
- **Inter-Service Communication**: Facilitate communication between different services by passing complex objects in a standardized, URL-safe format
- **Client-Side Storage Optimization**: Reduce the need for client-side storage by keeping serialized state in URLs or Cookies
- **Versioning Serialized Objects**: Enable versioning of serialized objects in URLs, allowing users to access different states or versions of data
- **Data Export/Import**: Simplify the export and import process of complex objects between different environments or systems by using URI-encoded data

This is just a fraction of what's possible with Universal ID. It's an invaluable tool for a range of development needs. API design, data management, user experience, and more. **Endless possibilities!**

<!-- Tocer[start]: Auto-generated, don't remove. -->

## Table of Contents

  - [Supported Data Types](#supported-data-types)
    - [Scalars](#scalars)
    - [Composites](#composites)
    - [ActiveRecord](#activerecord)
      - [Why Universal ID with ActiveRecord?](#why-universal-id-with-activerecord)
    - [Custom Datatypes](#custom-datatypes)
  - [Settings and Prepack Options](#settings-and-prepack-options)
  - [Advanced ActiveRecord](#advanced-activerecord)
  - [ActiveRecord::Relation Support](#activerecordrelation-support)
  - [SignedGlobalID](#signedglobalid)
  - [Performance and Benchmarks](#performance-and-benchmarks)
  - [Sponsors](#sponsors)
  - [License](#license)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

> :rocket: **Ready to Dive In?**: All the code examples below can be tested on your local machine. Simply clone the repo and run `bin/console` to begin exploring. Don't forget to execute `bundle` first to ensure all dependencies are up to date. Happy coding!


## Supported Data Types

### Scalars

Universal ID supports most Ruby primitives.

- `NilClass`
- `Complex`
- `Date`
- `DateTime`
- `FalseClass`
- `Float`
- `Integer`
- `NilClass`
- `Range`
- `Rational`
- `Regexp`
- `String`
- `Symbol`
- `Time`
- `TrueClass`

You can use Universal ID for individual primitives if desired, but scalar support is really the foundation for more serious use cases.
_See below..._

```ruby
uri = URI::UID.build(:demo).to_s
#=> "uid://universal-id/iwKA1gBkZW1vAw"

uid = URI::UID.parse(uri)
#=> #<URI::UID uid://universal-id/iwKA1gBkZW1vAw>

uid.decode
#=> :demo
```

### Composites

Composite support is where things start to get interesting. All of the composite datatypes listed below can be recursively transformed into a Universal ID.

<details>
  <summary><b><code>[]</code> Array</b>... ▾</summary>
  <p></p>

  ```ruby
  array = [1, 2, 3, [:a, :b, :c, [true]]]

  uri = URI::UID.build(array).to_s
  #=> "uid://universal-id/iweAlAECA5TUAGHUAGLUAGORwwM"

  uid = URI::UID.parse(uri)
  #=> #<URI::UID uid://universal-id/iweAlAECA5TUAGHUAGLUAGORwwM>

  uid.decode
  #=> [1, 2, 3, [:a, :b, :c, [true]]]
  ```
</details>

<details>
  <summary><b><code>{}</code> Hash</b>... ▾</summary>
  <p></p>

  ```ruby
  hash = {a: 1, b: 2, c: 3, array: [1, 2, 3, [:a, :b, :c, [true]]]}

  uri = URI::UID.build(hash).to_s
  #=> "uid://universal-id/CxKAhNQAYQHUAGIC1ABjA8cFAGFycmF5lAEC..."

  uid = URI::UID.parse(uri)
  #=> #<URI::UID uid://universal-id/CxKAhNQAYQHUAGIC1ABjA8cFAGFycmF5lAECA5TUAGHUAGLUAGORwwM>

  uid.decode
  #=> {:a=>1, :b=>2, :c=>3, :array=>[1, 2, 3, [:a, :b, :c, [true]]]}
  ```
</details>

<details>
  <summary><b><code><></code> Open Struct</b>... ▾</summary>
  <p></p>

  ```ruby
  ostruct = OpenStruct.new(
    name: "Wireless Keyboard",
    price: 49.99,
    category: "Electronics",
    in_stock: true
  )

  uri = URI::UID.build(ostruct).to_s
  #=> "uid://universal-id/iyaAx0sMhNYAbmFtZbFXaXJlbGVzcyBLZXlib2FyZMcFAHByaWNly0BI_rhR64Uf1wBjYXRlZ29ye..."

  uid = URI::UID.parse(uri)
  #=> #<URI::UID scheme=uid, host=universal-id, payload=iyaAx0sMhNYAbmFtZbFXaXJlbGVzcyBLZXlib2FyZMcFAHByaWNly0BI_rhR64Uf1wBjYXRlZ29ye...>

  uid.decode
  #=> #<OpenStruct name="Wireless Keyboard", price=49.99, category="Electronics", in_stock=true>
  ```
</details>

<details>
  <summary><b><code>()</code> Set</b>... ▾</summary>
  <p></p>

  ```ruby
  set = Set.new([1, 2, 3, [:a, :b, :c, [true]]])

  uri = URI::UID.build(set).to_s
  #=> "uid://universal-id/iwiA2AuUAQIDlNQAYdQAYtQAY5HDAw"

  uid = URI::UID.parse(uri)
  #=> #<URI::UID uid://universal-id/iwiA2AuUAQIDlNQAYdQAYtQAY5HDAw>

  URI::UID.parse(uri).decode
  #=> #<Set: {1, 2, 3, [:a, :b, :c, [true]]}>
  ```
</details>

<details>
  <summary><b><code><></code> Struct</b>... ▾</summary>
  <p></p>

  ```ruby
  Book = Struct.new(:title, :author, :isbn, :published_year)
  book = Book.new("The Great Gatsby", "F. Scott Fitzgerald", "9780743273565", 1925)

  uri = URI::UID.build(book).to_s
  #=> "uid://universal-id/G2YAoGTomv9N_4RV2oJRxRvZdC1wNJ0H3Ipu45kVcSrAxtg6Wjtogpi6GV1XXQAOAXoNR3BrCg9AQ..."

  uid = URI::UID.parse(uri)
  #=> #<URI::UID scheme=uid, host=universal-id, payload=G2YAoGTomv9N_4RV2oJRxRvZdC1wNJ0H3Ipu45kVcSrAxtg6Wjtogpi6GV1XXQAOAXoNR3BrCg9AQ...>

  uid.decode
  #=> #<struct Book title="The Great Gatsby", author="F. Scott Fitzgerald", isbn="9780743273565", published_year=1925>
  ```
</details>

### ActiveRecord

> :information_source: **Broad Compatibility**: Universal ID has built-in support for ActiveRecord, yet it maintains independence from Rails-specific dependencies. This versatile design enables integration into **any Ruby project**.

#### Why Universal ID with ActiveRecord?

While ActiveRecord already supports GlobalID, a robust library for serializing individual ActiveRecord models, Universal ID extends this functionality to cover a wider range of use cases. Here are a few reasons you may want to consider Universal ID.

- **Support for New Records**: Unlike GlobalID, Universal ID can serialize models that haven't been saved to the database yet
- **Capturing Unsaved Changes**: It can serialize ActiveRecord models with unsaved changes, ensuring that even transient states are captured
- **Association Handling**: Universal ID goes beyond single models. It can serialize associated records, including those with unsaved changes, creating a comprehensive snapshot of complex object states
- **Cloning Existing Records**: Need to make a copy of a record, including its associations? Universal ID handles this effortlessly, making it ideal for duplicating complex datasets
- **Granular Data Control**: With Universal ID, you gain explicit control over the serialization process. You can precisely choose which columns to include or exclude, allowing for tailored, optimized payloads that fit your specific needs
- **Efficient Query Serialization**: Universal ID extends its capabilities to ActiveRecord relations, enabling the serialization of complex queries and scopes. This feature allows for seamless sharing of query logic between processes, ensuring consistency and reducing redundancy in data handling tasks.

In summary, while GlobalID excels in its specific use case, Universal ID offers extended capabilities, particularly useful in scenarios involving unsaved records, complex associations, and data cloning.

<details>
  <summary><b>How to Convert Records to UIDs</b>... ▾</summary>
  <p></p>

  ```ruby
  ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

  ActiveRecord::Schema.define do
    create_table :campaigns do |t|
      t.column :name, :string
      t.timestamps
    end
  end

  class Campaign < ApplicationRecord
  end

  # ---

  campaign = Campaign.create(name: "Marketing Campaign")

  uri = URI::UID.build(campaign).to_s
  #=> "uid://universal-id/CwiAxw4EqENhbXBhaWdugaJpZAMD"

  uid = URI::UID.parse(uri)
  #=> #<URI::UID uid://universal-id/CwiAxw4EqENhbXBhaWdugaJpZAMD>

  URI::UID.parse(uri).decode
  ##<Campaign:0x000000011cc67da8 id: 1, name: "Marketing Campaign", ...>
  ```
</details>

### Custom Datatypes

Universal ID is **extensible** so you can register your own datatypes with specialized serialization rules.
It couldn't be simpler. Just convert the required data to a Ruby scalar or composite value.

<details>
  <summary><b>How to Register your own Datatype</b>... ▾</summary>
  <p></p>

  ```ruby
  class UserSettings
    attr_accessor :user_id, :preferences

    def initialize(user_id, preferences = {})
      @user_id = user_id
      @preferences = preferences
    end
  end

  UniversalID::MessagePackFactory.register(
    type: UserSettings,
    packer: ->(user_preferences, packer) do
      packer.write user_preferences.user_id
      packer.write user_preferences.preferences
    end,
    unpacker: ->(unpacker) do
      user_id = unpacker.read
      preferences = unpacker.read
      UserSettings.new user_id, preferences
    end
  )

  settings = UserSettings.new(1,
    theme: "dark",
    notifications: "email",
    language: "en",
    layout: "grid",
    privacy: "private"
  )

  uri = URI::UID.build(settings).to_s
  #=> "uid://universal-id/G1QAQAT-bfcGW1QOgadJwJF06yL8gDnGgfs1Xdti20TDDvG5STPqzbYcQ6TBqVKhdZ39CdQZUwEGe..."

  uid = URI::UID.parse(uri)
  #=> #<URI::UID uid://universal-id/G1QAQAT-bfcGW1QOgadJwJF06yL8gDnGgfs1Xdti20TDDvG5STPqzbYcQ6TBqVKhdZ39CdQZUwEGe..."

  uid.decode
  => #<UserSettings:0x0000000139157dd8 @preferences={:theme=>"dark", :notifications=>"email", :language=>"en", :layout=>"grid", :privacy=>"private"}, @user_id=1>
  ```
</details>

## Settings and Prepack Options

Universal ID supports a small but powerful set of configuration options for transforming objects before being
handed off to MessagePack for serialization.

Prepacking gives you explicit control over what data to include in the Universal ID.


<details>
  <summary><b>View All Settings and Prepack Options</b>... ▾</summary>
  <p></p>

  ```yml
  prepack:
    # ..........................................................................................................
    # A list of attributes to exclude (for objects like Hash, OpenStruct, Struct, etc.)
    # Takes prescedence over the`include` list
    exclude: []

    # ..........................................................................................................
    # A list of attributes to include (for objects like Hash, OpenStruct, Struct, etc.)
    include: []

    # ..........................................................................................................
    # Whether or not to omit blank values when packing (nil, {}, [], "", etc.)
    include_blank: true

    # ==========================================================================================================
    # Database records
    database:
      # ......................................................................................................
      # Whether or not to include primary/foreign keys
      # Setting this to `false` can be used to make a copy of an existing record
      include_keys: true

      # ......................................................................................................
      # Whether or not to include date/time timestamps (created_at, updated_at, etc.)
      # Setting this to `false` can be used to make a copy of an existing record
      include_timestamps: true

      # ......................................................................................................
      # Whether or not to include unsaved changes
      # Assign to `true` when packing new records
      include_unsaved_changes: false

      # ......................................................................................................
      # Whether or not to include loaded in-memory descendants (i.e. child associations)
      include_descendants: false

      # ......................................................................................................
      # The max depth (number) of loaded in-memory descendants to include when `include_descendants == true`
      # For example, a value of (3) would include the following:
      #   Parent > Child > Grandchild
      descendant_depth: 0
  ```
</details>

Prepack options can be applied when creating a Universal ID and can be passed in structured or flat format.

<details>
  <summary><b>How to Apply Prepack Options when Creating UIDs</b>... ▾</summary>
  <p></p>

  ```ruby
  person = {
    full_name: "Jane Doe",
    email: "janedoe@example.com",
    birthdate: "1980-05-15",
    phone_number: "555-6789",
    ssn: "123-45-6789",
    children: [
      {
        full_name: "Alice Doe",
        email: "alicedoe@example.com",
        birthdate: nil,
        phone_number: "555-1234",
        ssn: "987-65-4321"
      },
      {
        full_name: "Bob Doe",
        email: "bobdoe@example.com",
        birthdate: "2008-11-21",
        phone_number: nil,
        ssn: "456-12-1234"
      }
    ]
  }

  uid = URI::UID.build(person, include_blank: false, exclude: [:phone_number, :ssn])
  uid.decode

  # Note that the decoded payload is smaller due to the prepack options
  # Also note that the options were applied recursively

  {
    full_name: "Jane Doe",
    email: "janedoe@example.com",
    birthdate: "1980-05-15",
    children: [
      {
        full_name: "Alice Doe",
        email: "alicedoe@example.com"
      },
      {
        full_name: "Bob Doe",
        email: "bobdoe@example.com",
        birthdate: "2008-11-21"
      }
    ]
  }
  ```
</details>

It's also possible to register frequently used options as reusable settings to further simplify creating UIDs.

<details>
  <summary><b>How to Register Prepack Options as Preconfigured Settings</b>... ▾</summary>
  <p></p>

  ```yaml
  # app/config/unsaved.yml
  prepack:
    include_blank: false

    database:
      include_unsaved_changes: true
      include_timestamps: false
  ```

  ```ruby
  UniversalID::Settings.register :unsaved, YAML.safe_load("app/config/unsaved.yml")
  URI::UID.build @record, UniversalID::Settings[:small_record]
  ```
</details>

## Advanced ActiveRecord

Universal ID includes some advanced capabilities when used with ActiveRecord.

- [x] **Include loaded associations**
  Universal ID supports including `loaded` associations when a model is transformed into a UID.
  <small><em>Note that associations must be `loaded?` to be considered candidates for inclusion. There are multiple ways to achieve this, so be sure to [read up on associations](https://guides.rubyonrails.org/association_basics.html).</em></small>

- [x] **Include unsaved changes**
  Universal ID supports capturing unsaved change, for both new and persisted records, when a model is transformed into a UID.
  <small><em>This allows you to marshal complex unsaved data that can be restored at a later time. This feature supports several use cases, like allowing users to pause their work and resume at any point in the future without the need to store partial records in your database. And, because UIDs are web safe, you can hold this data in URLs, browser Cookies, Local/SessionStorage, etc.</em></small>

- [x] **Exclude keys** to make copies of existing records
  Universal ID supports making copies of individual records or entire collections by opt'ing to exclude keys when transorming to UID.
  <small><em>This allows you to make data sharable. Consider a sencario with complex infrastructure (db sharding, etc.). You can leverage Universal ID to move entire subsets of data across physical data stores.</em></small>

First, let's establish the schema structure and data we'll be working with.
We'll limit ourselves to 3 tables here, but Universal ID can support much more complex data models.

- Campaign
- Email
- Attachment

We'll use 1 campaign with 3 emails that have 2 attachments each.

<details>
  <summary><b>Setup the Schema</b>... ▾</summary>
  <p></p>

  ```ruby
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
  ```
</details>

<details>
  <summary><b>Setup the Models</b>... ▾</summary>
  <p></p>

  ```ruby
  class Campaign < ApplicationRecord
    has_many :emails, dependent: :destroy
  end

  class Email < ApplicationRecord
    belongs_to :campaign
    has_many :attachments, dependent: :destroy
  end

  class Attachment < ApplicationRecord
    belongs_to :email
  end
  ```
</details>


<details>
  <summary><b>Setup the Model Instances</b>... ▾</summary>
  <p></p>

  ```ruby
  campaign = Campaign.new(
    name: "Summer Sale Campaign",
    description: "A campaign for the summer sale, targeting our loyal customers.",
    trigger: "SummerStart"
  )

  # NOTE: Assigning campaign.emails via `=` to ensure ActiveRecord flags the association as `loaded`
  campaign.emails = 3.times.map do |i|
    email = campaign.emails.build(
      subject: "Summer Sale Special Offer #{i + 1}",
      body: "Dear Customer, check out our exclusive summer sale offers! #{i + 1}",
      wait: rand(1..14)
    )

    # NOTE: Assigning email.attachments via `=` to ensure ActiveRecord flags the association as `loaded`
    email.tap do |e|
      e.attachments = 2.times.map do |j|
        data = SecureRandom.random_bytes(rand(500..1500))
        e.attachments.build(
          file_name: "summer_sale_#{i + 1}_attachment_#{j + 1}.pdf",
          content_type: "application/pdf",
          file_size: data.size,
          file_data: data
        )
      end
    end
  end

  # demonstrate that we have new unsaved records

  #campaign
  campaign.new_record? # true
  campaign.changed? # true

  # emails
  campaign.emails.each do |email|
    email.new_record? # true
    email.changed? # true

    email.attachments.each do |attachment|
      attachment.new_record? # true
      attachment.changed? # true
    end
  end
  ```
</details>

Now let's look at how to leverage Universal ID with ActiveRecord.

<details>
  <summary><b>How to Include Unsaved Changes for New Records</b>... ▾</summary>
  <p></p>

  ```ruby
  # prepack options
  options = {
    include_unsaved_changes: true,
    include_descendants: true,
    descendant_depth: 2
  }

  # NOTE: The campaign model instance was setup earlier in the "Model Instances" section above
  campaign.new_record? # true
  campaign.changes
  # {
  #   "name"=>[nil, "Summer Sale Campaign"],
  #   "description"=>[nil, "A campaign for the summer sale, targeting our loyal customers."],
  #   "trigger"=>[nil, "SummerStart"]
  # }

  campaign.emails.each do |email|
    email.new_record? # true
    email.changes
    # {
    #   "subject"=>[nil, "Summer Sale Special Offer ..."],
    #   "body"=>[nil, "Dear Customer, check out our exclusive summer sale offers! ..."],
    #   "wait"=>[nil, ...]
    # }

    email.attachments.each do |attachment|
      attachment.new_record? # true
      attachment.changes
      # {
      #   "file_name"=>[nil, "summer_sale_..._attachment_....pdf"],
      #   "content_type"=>[nil, "application/pdf"],
      #   "file_size"=>[nil, ...],
      #   "file_data"=>[nil, "..."]
      # }
    end
  end

  encoded = URI::UID.build(campaign, options).to_s
  restored = URI::UID.parse(encoded).decode

  restored.new_record? # true
  restored.changes
  # {
  #   "name"=>[nil, "Summer Sale Campaign"],
  #   "description"=>[nil, "A campaign for the summer sale, targeting our loyal customers."],
  #   "trigger"=>[nil, "SummerStart"]
  # }

  restored.emails.each do |email|
    email.new_record? # true
    email.changes
    # {
    #   "subject"=>[nil, "Summer Sale Special Offer ..."],
    #   "body"=>[nil, "Dear Customer, check out our exclusive summer sale offers! ..."],
    #   "wait"=>[nil, ...]
    # }

    email.attachments.each do |attachment|
      attachment.new_record? # true
      attachment.changes
      # {
      #   "file_name"=>[nil, "summer_sale_..._attachment_....pdf"],
      #   "content_type"=>[nil, "application/pdf"],
      #   "file_size"=>[nil, ...],
      #   "file_data"=>[nil, "..."]
      # }
    end
  end
  ```
</details>

<details>
  <summary><b>How to Include Unsaved Changes for Persisted Records</b>... ▾</summary>
  <p></p>

  ```ruby
  # NOTE: The campaign model instance was setup earlier in the "Model Instances" section above
  # persist the model and its associations
  campaign.save!

  # make some unsaved changes to the records
  campaign.name = "Changed Name #{SecureRandom.hex}"
  campaign.emails.each do |email|
    email.subject = "Changed Subject #{SecureRandom.hex}"
    email.attachments.each do |attachment|
      attachment.file_name = "changed_file_name#{SecureRandom.hex}.pdf"
    end
  end

  campaign.persisted? # true
  campaign.changes
  # {"name"=>["Summer Sale Campaign", "Changed Name ..."]}

  campaign.emails.each do |email|
    email.persisted? # true
    email.changes
    # {"subject"=>["Summer Sale Special Offer 1", "Changed Subject ..."]}

    email.attachments.each do |attachment|
      attachment.persisted? # true
      attachment.changes
      # {"file_name"=>["summer_sale_..._attachment_....pdf", "changed_file_name....pdf"]}
    end
  end

  # prepack options
  options = {
    include_unsaved_changes: true,
    include_descendants: true,
    descendant_depth: 2
  }

  encoded = URI::UID.build(campaign, options).to_s
  restored = URI::UID.parse(encoded).decode

  restored.persisted? # true
  restored.changes
  # {"name"=>["Summer Sale Campaign", "Changed Name ..."]}

  restored.emails.each do |email|
    email.persisted? # true
    email.changes
    # {"subject"=>["Summer Sale Special Offer 1", "Changed Subject ..."]}

    email.attachments.each do |attachment|
      attachment.persisted? # true
      attachment.changes
      # {"file_name"=>["summer_sale_..._attachment_....pdf", "changed_file_name....pdf"]}
    end
  end
  ```
</details>

<details>
  <summary><b>How to Copy Persisted Records</b>... ▾</summary>
  <p></p>

  ```ruby
  # NOTE: The campaign model instance was setup earlier in the "Model Instances" section above
  # persist the model and its associations
  campaign.save!

  options = {
    include_keys: false,
    include_timestamps: false,
    include_unsaved_changes: true,
    include_descendants: true,
    descendant_depth: 2
  }

  encoded = URI::UID.build(campaign, options).to_s
  copy = URI::UID.parse(encoded).decode

  campaign.persisted? # false
  copy.new_record? # true
  copy.save!

  copy == campaign # false

  campaign.emails.each do |email|
    copy_email_ids = copy.emails.map(&:id)
    campaign_email_ids = campaign.emails.map(&:id)
    (copy_email_ids && campaign_email_ids).any? # false

    copy_attachment_ids = copy.emails.map(&:attachments).flatten.map(&:id)
    campaign_attachment_ids = campaign.emails.map(&:attachments).flatten.map(&:id)
    (copy_attachment_ids & campaign_attachment_ids).any? # false
  end
  ```
</details>

## ActiveRecord::Relation Support

Universal ID seamlessly handles the serialization of ActiveRecord relations and scopes, striking the perfect balance between efficiency and functionality. It paves the way for easy, optimized, and effective sharing of database queries. This capability transforms query management, allowing developers to encapsulate complex query structures into a reliable, portable, and reusable format that ensures query consistency across different parts of the application.

> :bulb: **Optimized Payloads**: When handling `ActiveRecord::Relations`, Universal ID intelligently clears cached data within the relation before encoding. This approach minimizes payload size, ensuring efficient data transfer without sacrificing the integrity of the original query logic.

<details>
  <summary><b>How to work with ActiveRecord::Relations</b>... ▾</summary>
  <p></p>

  ```ruby
  # Assuming we have multiple campaigns already stored in the database
  relation = Campaign.joins(:emails).where("emails.subject LIKE ?", "Flash Sale%")

  # force load the relation
  relation.load
  relation.loaded? # true

  encoded = URI::UID.build(relation).to_s
  decoded = URI::UID.parse(encoded).decode

  decoded.is_a? ActiveRecord::Relation # true
  decoded.loaded? # false
  decoded == relation # true
  decoded.size == relation.size # true
  decoded.to_a == relation.to_a # true
  ```
</details>

## SignedGlobalID

Features like `signing` _(to prevent tampering)_, `purpose`, and `expiration` are provided by SignedGlobalIDs.
These features _(and more)_ will eventually be added to UniversalID, but until then...
simply convert your UniversalID to a SignedGlobalID to add these features to any Universal ID.

<details>
  <summary><b>How to Convert a UID to/from a SignedGlobalID</b>... ▾</summary>
  <p></p>

  ```ruby
  product = {
    name: "Wireless Bluetooth Headphones",
    price: 79.99,
    category: "Electronics"
  }

  uid = URI::UID.build(product)
  #=> #<URI::UID scheme="uid", host="universal-id", path="/G0sAgBypU587HsjkLpEnGHiaWfPQEyiiuH6j...">

  sgid = uid.to_sgid_param(for: "cart-123", expires_in: 1.hour)
  #=> "eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJZ0d4WjJsa09pOHZkVzVwZG1WeWMyRnNMV2xrTDFWU1NUbzZWVWxFT2pwSGJHOWlZV3hKUkZKbFkyOXlaQzlITUhO..."

  URI::UID.from_sgid(sgid, for: "cart-123").decode
  #=> {
  #     name: "Wireless Bluetooth Headphones",
  #     price: 79.99,
  #     category: "Electronics"
  #   }


  # mismatched purpose returns nil... as expected
  URI::UID.from_sgid(sgid, for: "mismatch")
  #=> nil
  ```
</details>

## Performance and Benchmarks

<details>
  <summary><b>View Benchmarks</b>... ▾</summary>
  <p></p>

  Benchmarks can be performed by cloning the project and running `bin/bench`.
  The run below was performed on the following hardware.

  ```
  Model Name: MacBook Air
  Model Identifier: MacBookAir10,1
  Chip: Apple M1
  Total Number of Cores: 8 (4 performance and 4 efficiency)
  Memory: 16 GB
  ```

  ```
  Benchmarking with the following ActiveRecord/Hash data...
  ==================================================================================================
  {
               "id" => 1,
             "name" => "Production",
      "description" => "RISC is good Well then get your shit together. Get it all together and put it in a backpack, all your shit, so it's together. ...and if you gotta take it somewhere, take it somewhere ya know? Take it to the shit store and sell it, or put it in a shit museum. I don't care what you do, you just gotta get it together... Get your shit together. Mark it zero! What you do not smell is called Iocane Power. You wanna hear a lie? ... I...think you're great. You're my best friend.",
          "trigger" => "Political Organization enhance web-enabled architectures",
       "created_at" => "2023-11-11T01:28:46.657Z",
       "updated_at" => "2023-11-11T01:28:46.657Z",
           "emails" => [
          [0] {
                       "id" => 1,
              "campaign_id" => 1,
                  "subject" => "drive synergistic web-readiness",
                     "body" => "But first things first. To the death! I feel like all my kids grew up, and then they married each other. It's every parents' dream. Koona t'chuta Solo? (Going somewhere Solo?)",
                     "wait" => nil,
               "created_at" => "2023-11-11T01:28:46.661Z",
               "updated_at" => "2023-11-11T01:28:46.675Z",
              "attachments" => [
                  [0] {
                                "id" => 1,
                          "email_id" => 1,
                         "file_name" => "Schneider and Sons",
                      "content_type" => "Enterprise-wide 4th generation complexity",
                         "file_size" => nil,
                         "file_data" => nil,
                        "created_at" => "2023-11-11T01:28:46.664Z",
                        "updated_at" => "2023-11-11T01:28:46.670Z"
                  },
                  [1] {
                                "id" => 2,
                          "email_id" => 1,
                         "file_name" => "Devolved solution-oriented circuit",
                      "content_type" => "revolutionize magnetic bandwidth Intelligent Paper Gloves",
                         "file_size" => nil,
                         "file_data" => nil,
                        "created_at" => "2023-11-11T01:28:46.664Z",
                        "updated_at" => "2023-11-11T01:28:46.670Z"
                  }
              ]
          },
          [1] {
                       "id" => 2,
              "campaign_id" => 1,
                  "subject" => "Marketing",
                     "body" => "I'll explain and I'll use small words so that you'll be sure to understand, you warthog faced buffoon. Well then get your shit together. Get it all together and put it in a backpack, all your shit, so it's together. ...and if you gotta take it somewhere, take it somewhere ya know? Take it to the shit store and sell it, or put it in a shit museum. I don't care what you do, you just gotta get it together... Get your shit together. I am running away from my responsibilities. And it feels good.",
                     "wait" => nil,
               "created_at" => "2023-11-11T01:28:46.671Z",
               "updated_at" => "2023-11-11T01:28:46.675Z",
              "attachments" => [
                  [0] {
                                "id" => 3,
                          "email_id" => 2,
                         "file_name" => "Weber-Schulist benchmark open-source applications",
                      "content_type" => "Enormous Linen Shoes synthesize customized e-services",
                         "file_size" => nil,
                         "file_data" => nil,
                        "created_at" => "2023-11-11T01:28:46.672Z",
                        "updated_at" => "2023-11-11T01:28:46.672Z"
                  },
                  [1] {
                                "id" => 4,
                          "email_id" => 2,
                         "file_name" => "thought leadership",
                      "content_type" => "Business Development Enhanced logistical collaboration",
                         "file_size" => nil,
                         "file_data" => nil,
                        "created_at" => "2023-11-11T01:28:46.672Z",
                        "updated_at" => "2023-11-11T01:28:46.672Z"
                  }
              ]
          },
          [2] {
                       "id" => 3,
              "campaign_id" => 1,
                  "subject" => "Mediocre Aluminum Car",
                     "body" => "Don’t even trip dawg. Stay away from my special lady friend, man.",
                     "wait" => nil,
               "created_at" => "2023-11-11T01:28:46.672Z",
               "updated_at" => "2023-11-11T01:28:46.675Z",
              "attachments" => [
                  [0] {
                                "id" => 5,
                          "email_id" => 3,
                         "file_name" => "Import and Export",
                      "content_type" => "Heavy Duty Paper Bench Project Management",
                         "file_size" => nil,
                         "file_data" => nil,
                        "created_at" => "2023-11-11T01:28:46.673Z",
                        "updated_at" => "2023-11-11T01:28:46.674Z"
                  },
                  [1] {
                                "id" => 6,
                          "email_id" => 3,
                         "file_name" => "synthesize ubiquitous architectures Corporate Communications",
                      "content_type" => "Durable Rubber Watch",
                         "file_size" => nil,
                         "file_data" => nil,
                        "created_at" => "2023-11-11T01:28:46.674Z",
                        "updated_at" => "2023-11-11T01:28:46.674Z"
                  }
              ]
          }
      ]
  }
  ==================================================================================================
  Benchmarking 5000 iterations
  ==================================================================================================
                                                             user     system      total        real
  URI::UID.build Hash                                   14.770667   0.102535  14.873202 ( 14.898856)
  Average                                                0.002954   0.000021   0.002975 (  0.002980)
  ..................................................................................................
                                                             user     system      total        real
  URI::UID.build Hash, include_blank: false             13.821420   0.066910  13.888330 ( 13.892066)
  Average                                                0.002764   0.000013   0.002778 (  0.002778)
  ..................................................................................................
                                                             user     system      total        real
  URI::UID.parse HASH/UID                                0.075566   0.000411   0.075977 (  0.076035)
  Average                                                0.000015   0.000000   0.000015 (  0.000015)
  ..................................................................................................
                                                             user     system      total        real
  URI::UID.decode HASH/UID                               0.111007   0.003572   0.114579 (  0.114587)
  Average                                                0.000022   0.000001   0.000023 (  0.000023)
  ..................................................................................................
                                                             user     system      total        real
  URI::UID.build ActiveRecord                            0.984594   0.010059   0.994653 (  0.994662)
  Average                                                0.000197   0.000002   0.000199 (  0.000199)
  ..................................................................................................
                                                             user     system      total        real
  URI::UID.build ActiveRecord, exclude_blank             0.953653   0.006692   0.960345 (  0.960765)
  Average                                                0.000191   0.000001   0.000192 (  0.000192)
  ..................................................................................................
                                                             user     system      total        real
  URI::UID.build ActiveRecord, include_descendants      44.958468   0.170125  45.128593 ( 45.176116)
  Average                                                0.008992   0.000034   0.009026 (  0.009035)
  ..................................................................................................
                                                             user     system      total        real
  URI::UID.parse ActiveRecord/UID                        0.119030   0.000319   0.119349 (  0.119525)
  Average                                                0.000024   0.000000   0.000024 (  0.000024)
  ..................................................................................................
                                                             user     system      total        real
  URI::UID.decode HASH/UID                               5.198092   0.024652   5.222744 (  5.282794)
  Average                                                0.001040   0.000005   0.001045 (  0.001057)
  ..................................................................................................
                                                             user     system      total        real
  UID > GID > UID.decode include_descendants            55.612061   0.398193  56.010254 ( 57.372350)
  Average                                                0.011122   0.000080   0.011202 (  0.011474)
  ..................................................................................................
                                                             user     system      total        real
  UID > SGID > UID.decode include_descendants           55.406590   0.260552  55.667142 ( 56.432082)
  Average                                                0.011081   0.000052   0.011133 (  0.011286)
  ..................................................................................................
  ```
</details>

## Sponsors

<p align="center">
  <em>Proudly sponsored by</em>
</p>
<p align="center">
  <a href="https://www.clickfunnels.com?utm_source=hopsoft&utm_medium=open-source&utm_campaign=universalid">
    <img src="https://images.clickfunnel.com/uploads/digital_asset/file/176632/clickfunnels-dark-logo.svg" width="575" />
  </a>
</p>

[Add your company...](https://github.com/sponsors/hopsoft/sponsorships?sponsor=hopsoft&tier_id=23918&preview=false)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
