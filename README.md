<p align="center">
  <h1 align="center">Universal ID</h1>
  <p align="center">
    <a href="http://blog.codinghorror.com/the-best-code-is-no-code-at-all/">
      <img alt="Lines of Code" src="https://img.shields.io/badge/loc-745-47d299.svg" />
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
  <h2 align="center">URL-Safe Portability for any Ruby Object</h2>
</p>

**Universal ID introduces a paradigm shift in Ruby development with powerful recursive serialization.**
This innovative library transforms any Ruby object into a URL-safe string, enabling efficient encoding and seamless data transfer across process boundaries. By simplifying complex serialization tasks, Universal ID enhances both the developer and end-user experience, paving the way for a wide range of use cases—from state preservation in web apps to inter-service communication.

It leverages both [MessagePack](https://msgpack.org/) and [Brotli](https://github.com/google/brotli) _(a combo built for speed and best-in-class data compression)_.
MessagePack + Brotli is up to 30% faster and within 2-5% compression rates compared to Protobuf. <a title="Source" href="https://g.co/bard/share/e5bdb17aee91">↗</a>

<!-- Tocer[start]: Auto-generated, don't remove. -->

## Table of Contents

  - [Example Use Cases](#example-use-cases)
  - [Supported Data Types](#supported-data-types)
    - [Scalars](#scalars)
    - [Composites](#composites)
    - [Custom Types](#custom-types)
    - [Contributed Types](#contributed-types)
  - [Settings and Prepack Options](#settings-and-prepack-options)
  - [Advanced ActiveRecord](#advanced-activerecord)
  - [ActiveRecord::Relation Support](#activerecordrelation-support)
  - [SignedGlobalID](#signedglobalid)
  - [Fingerprinting (Implicit Versioning)](#fingerprinting-implicit-versioning)
  - [Performance and Benchmarks](#performance-and-benchmarks)
  - [Sponsors](#sponsors)
  - [License](#license)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

## Example Use Cases

Universal ID's powerful serialization capabilities unlock a myriad of possibilities across various domains.
Here are a few possibilities.

- **State Management for Web Applications**:
  Facilitate seamless user experiences in web applications by preserving and transferring UI states, even across different sessions.

- **Data Serialization for Distributed Systems**:
  Enable efficient communication in distributed systems by serializing complex data structures for network transmission.

- **Configuration Settings for Software Applications**:
  Store and manage configuration settings for software applications, allowing easy transfer and versioning of settings across installations.

- **Session Continuity in Cloud Services**:
  Ensure continuity of user sessions in cloud-based applications, enabling users to pick up their work exactly where they left off, regardless of the device or location.

- **Audit Logging for Complex Transactions**:
  Record detailed states of complex transactions in audit logs, providing a comprehensive and reversible record of actions for compliance and analysis.

- **Machine-to-Machine Communication**:
  Standardize data formats for machine-to-machine communication, facilitating interoperability and data exchange in IoT and other automated systems.

These use cases demonstrate the versatility and power of Universal ID in various application and business scenarios, offering solutions that enhance efficiency, user experience, and system reliability.

<details>
  <summary><b>See More Use Cases</b>... ▾</summary>
  <p></p>

  Harnessing the capabilities of this advanced low-level tool in your libraries and applications might initially seem daunting.
  To assist you in unlocking its full potential, here are some additional suggestions to help you get started.

  - **API Response Caching**
    Cache complex API responses as serialized strings, allowing for efficient storage and quick retrieval.

  - **Asset Management in Enterprises**
    Serialize asset information, including status and location, for efficient tracking and management.

  - **Audit Logging for Financial Transactions**
    Serialize transaction states for audit trails in financial applications, providing detailed and reversible records for compliance.

  - **Automated Testing of Web Applications**
    Serialize application states to reproduce and test various scenarios automatically.

  - **Backup and Restore of Application States**
    Create snapshots of application states that can be backed up and later restored.

  - **Configuration Management in DevOps**
    Serialize configuration settings for software deployments, enabling easy versioning and rollback.

  - **Content Management Systems (CMS)**
    Serialize page or post states in CMS, enabling advanced versioning and preview functionalities.

  - **Customer Support Tools**
    Serialize user issues and their context, helping support teams to quickly understand and resolve customer problems.

  - **Data Migration Between Databases**
    Serialize entire database records for easy transfer between different database systems or formats.

  - **Educational Platforms**
    Serialize user progress and states in educational platforms, allowing students to pause and resume their learning activities.

  - **E-commerce Cart Persistence**
    Serialize shopping cart contents, enabling users to return to a filled cart even after their session expires.

  - **Energy Management Systems**
    Serialize energy usage data from various sensors for analysis and monitoring.

  - **Environmental Monitoring Systems**
    Serialize sensor data from environmental monitoring systems for analysis and historical record keeping.

  - **Event Sourcing in Applications**
    Use serialized states for event sourcing, maintaining an immutable log of state changes over time.

  - **Gaming State Preservation**
    Store game states as serialized strings, allowing players to resume games exactly where they left off.

  - **Healthcare Data Exchange**
    Securely transfer patient data between different healthcare systems while maintaining the integrity of complex data structures.

  - **IoT Device State Management**
    Serialize the state of IoT devices for efficient transmission over networks, aiding in remote monitoring and control.

  - **Legal Document Management**
    Serialize versions of legal documents, maintaining a trail of edits and changes for auditing.

  - **Machine Learning Data Preparation**
    Serialize complex data structures used in machine learning pipelines for efficient processing.

  - **Microservice Communication**
    Serialize complex objects for inter-service communication, ensuring efficient data transfer and reducing the need for complex parsing logic.

  - **Real Estate Portfolio Management**
    Serialize complex property data for portfolio management and analysis.

  - **Real-time Collaboration Tools**
    Serialize document or application states for real-time collaboration tools, ensuring consistency across different user sessions.

  - **Research Data Management**
    Serialize research data and experimental setups for ease of sharing and replication of experiments.

  - **Retail Inventory Management**
    Serialize inventory data, including details of products, for efficient management and tracking.

  - **Session Continuity Across Devices**
    Store user session data as a serialized string, enabling users to resume their session on a different device without loss of context.

  - **State Management for Single Page Applications (SPAs)**
    Serialize UI states into URL-safe strings, enabling bookmarking or sharing of specific application states.

  - **Supply Chain Logistics**
    Serialize complex logistics and shipment data, aiding in efficient tracking and management.

  - **Telecommunication Network Management**
    Serialize configurations and states of network devices for efficient management and troubleshooting.

  - **Travel Itinerary Planning**
    Serialize travel plans and itineraries, allowing users to save and share their travel details easily.

  - **Version Control of Design Files**
    Serialize design artifacts for version control in graphic design and CAD applications.
</details>

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

### Custom Types

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

### Contributed Types

Universal ID is designed to be highly extensible, allowing for third-party contributions to enhance its capabilities.
These contributions can introduce support for additional data types, further broadening the scope of Universal ID’s utility.
The following are some notable contrib extensions:

- **ActiveRecord::Base**:
  Integrates Universal ID with ActiveRecord base models, enabling intelligent serialization of database records.

- **ActiveRecord::Relation**:
  Supports the serialization of ActiveRecord relations, making it possible to encode complex query structures.

- **ActiveSupport::TimeWithZone**:
  Adds the ability to serialize ActiveSupport's TimeWithZone objects.

- **GlobalID**:
  Extends support to include GlobalIDs.

- **SignedGlobalID**:
  Extends support to include SignedGlobalIDs.

**Requiring Contributed Types**

To utilize the contributed types, you must explicitly require them in your application.
This ensures the extensions are loaded and available for use.
Here is an example illustrating how to include contributed types:

```ruby
# load contrib types
require "universal_id/contrib/active_record"
require "universal_id/contrib/active_support"
require "universal_id/contrib/global_id"
require "universal_id/contrib/signed_global_id"

# or simply
require "universal_id/contrib/rails"
```

> :bulb: **Implicit Contribs**: Whenever the `Rails` constant is defined, the related contribs are auto-loaded.

> :bulb: **Broad Compatibility**: Universal ID has built-in support for ActiveRecord, yet it maintains independence from Rails-specific dependencies. This versatile design enables integration into **any Ruby project**.

**Why Universal ID with ActiveRecord?**

While ActiveRecord already supports GlobalID, a robust library for serializing individual ActiveRecord models, Universal ID extends this functionality to cover a wider range of use cases. Here are a few reasons you may want to consider Universal ID.

- **Support for New Records**:
  Unlike GlobalID, Universal ID can serialize models that haven't been saved to the database yet.

- **Capturing Unsaved Changes**:
  It can serialize ActiveRecord models with unsaved changes, ensuring that even transient states are captured.

- **Association Handling**:
  Universal ID goes beyond single models. It can serialize associated records, including those with unsaved changes, creating a comprehensive snapshot of complex object states.

- **Cloning Existing Records**:
  Need to make a copy of a record, including its associations? Universal ID handles this effortlessly, making it ideal for duplicating complex datasets.

- **Granular Data Control**:
  With Universal ID, you gain explicit control over the serialization process. You can precisely choose which columns to include or exclude, allowing for tailored, optimized payloads that fit your specific needs.

- **Efficient Query Serialization**:
  Universal ID extends its capabilities to ActiveRecord relations, enabling the serialization of complex queries and scopes. This feature allows for seamless sharing of query logic between processes, ensuring consistency and reducing redundancy in data handling tasks.

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
  UniversalID::Settings.register :unsaved, File.expand_path("app/config/unsaved.yml", __dir__)
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

## Fingerprinting (Implicit Versioning)

Fingerprinting adds an extra layer of intelligence to the serialization process.
UIDs automatically include a "fingerprint" for each serialized object based on the target object's class and
its modification time _(mtime)_... based on the file that defined the object's class.

Fingerprints are comprised of the following components:

1. `Class (Class)`  - The encoded object's class
2. `Timestamp (Time)` - The mtime (UTC) of the file that defined the object's class

> :bulb: **Modification Timestamp**: The `mtime` is detected and captured the moment a UID is built or created.

The primary benefit of this approach is that it allows developers to manage different versions of serialized data effectively...
**without the need for custom versioning solutions**. Whenever the class definition changes, the mtime updates, resulting in a different fingerprint for new serializations.
This is especially useful in scenarios where the data format might evolve over time, such as in long-lived applications or systems with persistent serialized data.

<details>
  <summary><b>How to Use Fingerprinting</b>... ▾</summary>
  <p></p>

  1. Build a UID using a custom handler _(optional Ruby block)_. This allows you to take control of the encoding process.

  ```ruby
  # NOTE: The campaign model instance was setup earlier in the "Model Instances" section above
  campaign.save!

  #           the uid build target (campaign in this case)
  #                                    |
  #                                    |  encoding options (whatever was passed to URI::UID.build or {})
  #                                    |        |
  uid = URI::UID.build(campaign) do |record, options|
    data = { id: record.id, demo: true }
    URI::UID.encode data, options.merge(include: %w[id demo])
  end
  ```

  2. Decode the UID using a custom handler _(optional Ruby block)_. This allows you to take control of the decoding process.

  ```ruby
  #                                                  fingerprint components
  #                                                         ____|______
  #                        the decoded data from above      |         |
  #                                              |          |         |
  decoded = URI::UID.parse(uid.to_s).decode do |data, class_name, timestamp|
    data = decoder.decode(payload)
    record = Object.const_get(class_name).find_by(id: data[:id])
    record.instance_variable_set(:@demo, data[:demo])

    case Time.parse(timestamp)
    when 3.months.ago..Time.now
      # current data format
      # return the record as-is
      record
    when 1.year.ago..3.months.ago
      # outdated data format
      # apply an ETL process to bring the outdated data current
      # then return the modified record
      record
    end
  end
  ```
</details>

Fingerprinting allows for seamless handling of different data versions and formats,
making it invaluable for maintaining consistency and reliability in applications dealing with serialized data over time.

> :bulb: **Optional Usage**: While fingerpint creation is automatic and implicit, using it is optional... ready whenever you want more control.

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
