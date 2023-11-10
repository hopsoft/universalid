<p align="center">
  <h1 align="center">Universal ID 🌌</h1>
  <p align="center">
    <a href="http://blog.codinghorror.com/the-best-code-is-no-code-at-all/">
      <img alt="Lines of Code" src="https://img.shields.io/badge/loc-670-47d299.svg" />
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
  <h2 align="center">Powerful Web-Safe Portability for Ruby Objects</h2>
</p>

Universal ID is a Ruby library that supports recursive serialization/deserialization of any Ruby object to/from a URL-safe Base64 URI. The encoded payload can be transported across process boundaries and can also be used in standard web URLs.

UID is built on top of [MessagePack](https://msgpack.org/) and [Brotli](https://github.com/google/brotli) _(a combo built for speed and best-in-class data compression)_.

## Use Cases

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

This short list highlights the flexibility and convenience of encoding complex Ruby objects into a compact, URL-safe format, making the Universal ID library a powerful tool for various uses in web development, API design, data management, and more. **The possibilities are endless and only limited by your imagination!**

<!-- Tocer[start]: Auto-generated, don't remove. -->

## Table of Contents

  - [Supported Data Types](#supported-data-types)
    - [Scalars](#scalars)
    - [Composites](#composites)
    - [Advanced Types](#advanced-types)
      - [ActiveRecord](#activerecord)
      - [Extend Behavior with Custom Datatypes](#extend-behavior-with-custom-datatypes)
  - [Prepack Options](#prepack-options)
  - [GlobalID and SignedGlobalID](#globalid-and-signedglobalid)
    - [TODO: write this...](#todo-write-this)
  - [Advanced ActiveRecord](#advanced-activerecord)
    - [TODO: write this...](#todo-write-this-1)
  - [Performance and Benchmarks](#performance-and-benchmarks)
  - [License](#license)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

## Supported Data Types

### Scalars

Universal ID supports most Ruby primitives. _Including but not limited to the following._

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

You can use Universal ID for for individual scalar values if desired, but scalar support is the foundation for more serious use cases.
_Think of scalars as the low level building blocks._

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
  #=> "CxKAhNQAYQHUAGIC1ABjA8cFAGFycmF5lAEC..."

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

### Advanced Types

Universal ID supports advanced datatypes like database records and more...
In fact, Universal ID can be extended with custom datatypes.

#### ActiveRecord

ActiveRecord models can be easily converted to UIDs.

<details>
  <summary><b>UIDs for Database Models</b>... ▾</summary>
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

  > :question: Why not just use [GlobalID](https://github.com/rails/globalid)? Read on to learn why UID may be a better option for your application.
</details>

#### Extend Behavior with Custom Datatypes

Universal ID is **extensible** so you can register your own datatypes with specialized serialization rules.
It couldn't be simpler. Just convert the required data to a Ruby scalar or composite value.

<details>
  <summary><b>Registering your own Datatype</b>... ▾</summary>
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
      theme: "dark", # User preference for UI theme
      notifications: "email", # How the user prefers to receive notifications
      language: "en", # Preferred language
      layout: "grid", # Preferred layout for viewing content
      privacy: "private" # Privacy settings
    )

    uri = URI::UID.build(settings).to_s
    #=> "uid://universal-id/G1QAQAT-bfcGW1QOgadJwJF06yL8gDnGgfs1Xdti20TDDvG5STPqzbYcQ6TBqVKhdZ39CdQZUwEGe..."

    uid = URI::UID.parse(uri)
    #=> #<URI::UID uid://universal-id/G1QAQAT-bfcGW1QOgadJwJF06yL8gDnGgfs1Xdti20TDDvG5STPqzbYcQ6TBqVKhdZ39CdQZUwEGe..."

    uid.decode
    => #<UserSettings:0x0000000139157dd8 @preferences={:theme=>"dark", :notifications=>"email", :language=>"en", :layout=>"grid", :privacy=>"private"}, @user_id=1>
    ```
</details>

## Prepack Options

Universal ID supports a small but powerful set of configuration options for transforming objects before being
delivered to [MessagePack](https://msgpack.org/) for serialization.

Prepacking gives you more control of what data gets included in the Universal ID.

```yml
prepack:
  # ..........................................................................................................
  # A list of attributes to exclude (default includes all keys)
  # Takes prescedence over the`include` list
  exclude: []

  # ..........................................................................................................
  # A list of attributes to include (default includes all keys)
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

Prepack options can be applied when creating a Universal ID and can be passed in structured or flat format.

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

It's also possible to register frequently used options as reusable settings.

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

## Advanced ActiveRecord

### New Records

### Descendants

### Deep Copies

## SignedGlobalID

Options like `signing`, `purpose`, and `expiration` are some of the best things provided by SignedGlobalID.
These options _(and more)_ will eventually be folded into UniversalID, but until then
you can simply cast your UniversalID to a SignedGlobalID to pick up these features.


<details>
  <summary><b>Convert a UID to/from a SignedGlobalID</b>... ▾</summary>
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

  URI::UID.from_sgid(sgid).decode
  #=> {
  #     name: "Wireless Bluetooth Headphones",
  #     price: 79.99,
  #     category: "Electronics"
  #   }


  # mismatched purpose returns nil... as expected
  URI::UID.from_sgid sgid, for: "mismatch"
  #=> nil
  ```

</details>

## Performance and Benchmarks

<details>
  <summary><b>Benchmarks</b>... ▾</summary>
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
            "name" => "Awesome Leather Bag Stand-alone regional model",
      "description" => "You wanna hear a lie? ... I...think you're great. You're my best friend. It's not my fault being the biggest and the strongest. I don't even exercise. Congratulations. No one's ever beat her before. You just made an enemy for life Talk Jabba. (Tell that to Jabba.) You want a toe? I can get you a toe, believe me. There are ways, Dude. You don't wanna know about it, believe me.",
          "trigger" => "Incredible Plastic Clock ideate",
      "created_at" => "2023-11-09T20:25:47.405Z",
      "updated_at" => "2023-11-09T20:25:47.405Z",
          "emails" => [
          [0] {
                      "id" => 1,
              "campaign_id" => 1,
                  "subject" => "Human Resources Heavy Duty Copper Plate",
                    "body" => "I don't play well with others That's the difference between you and me, Morty. I never go back to the carpet store. It's weird. They always travel in groups of five. These programmers, there's always a tall, skinny white guy; short, skinny Asian guy; fat guy with a ponytail; some guy with crazy facial hair; and then an East Indian guy. It's like they trade guys until they all have the right group.",
                    "wait" => nil,
              "created_at" => "2023-11-09T20:25:47.409Z",
              "updated_at" => "2023-11-09T20:25:47.425Z",
              "attachments" => [
                  [0] {
                                "id" => 1,
                          "email_id" => 1,
                        "file_name" => "home stretch",
                      "content_type" => "Ferry-Cronin",
                        "file_size" => nil,
                        "file_data" => nil,
                        "created_at" => "2023-11-09T20:25:47.412Z",
                        "updated_at" => "2023-11-09T20:25:47.421Z"
                  },
                  [1] {
                                "id" => 2,
                          "email_id" => 1,
                        "file_name" => "Writing and Editing Bogan, Upton and Lang",
                      "content_type" => "McCullough, Leffler and Morar Decentralized dedicated function",
                        "file_size" => nil,
                        "file_data" => nil,
                        "created_at" => "2023-11-09T20:25:47.413Z",
                        "updated_at" => "2023-11-09T20:25:47.421Z"
                  }
              ]
          },
          [1] {
                      "id" => 2,
              "campaign_id" => 1,
                  "subject" => "Cummings, Veum and Lockman Human Resources",
                    "body" => "Yeah, well, that's just, like, your opinion, man. You listen to me, you muscle-bound handsome Adonis: tech is reserved for people like me, okay? The freaks, the weirdos, the misfits, the geeks, the dweebs, the dorks! Not you! Would I rather be feared or loved? Easy. Both. I want people to be afraid of how much they love me. I'm more than just a hammer.",
                    "wait" => nil,
              "created_at" => "2023-11-09T20:25:47.421Z",
              "updated_at" => "2023-11-09T20:25:47.425Z",
              "attachments" => [
                  [0] {
                                "id" => 3,
                          "email_id" => 2,
                        "file_name" => "Sleek Rubber Shirt",
                      "content_type" => "snackable content Heidenreich, Rau and Blanda",
                        "file_size" => nil,
                        "file_data" => nil,
                        "created_at" => "2023-11-09T20:25:47.422Z",
                        "updated_at" => "2023-11-09T20:25:47.423Z"
                  },
                  [1] {
                                "id" => 4,
                          "email_id" => 2,
                        "file_name" => "Optional 6th generation solution",
                      "content_type" => "expansion play Synergistic Granite Bag",
                        "file_size" => nil,
                        "file_data" => nil,
                        "created_at" => "2023-11-09T20:25:47.422Z",
                        "updated_at" => "2023-11-09T20:25:47.423Z"
                  }
              ]
          },
          [2] {
                      "id" => 3,
              "campaign_id" => 1,
                  "subject" => "branding Outsourcing / Offshoring",
                    "body" => "God gave men brains larger than dogs so they wouldn't hump women's legs at cocktail parties I do not think you would accept my help, since I am only waiting around to kill you. I was gonna sleep last night, but, uh... I thought I had this solve for this computational trust issue I've been working on, but it turns out, I didn't have a solve. But it was too late. I had already drank the whole pot of coffee. I am running away from my responsibilities. And it feels good.",
                    "wait" => nil,
              "created_at" => "2023-11-09T20:25:47.423Z",
              "updated_at" => "2023-11-09T20:25:47.425Z",
              "attachments" => [
                  [0] {
                                "id" => 5,
                          "email_id" => 3,
                        "file_name" => "Ergonomic Rubber Clock",
                      "content_type" => "Nanotechnology best practice",
                        "file_size" => nil,
                        "file_data" => nil,
                        "created_at" => "2023-11-09T20:25:47.424Z",
                        "updated_at" => "2023-11-09T20:25:47.424Z"
                  },
                  [1] {
                                "id" => 6,
                          "email_id" => 3,
                        "file_name" => "disintermediate innovative e-commerce",
                      "content_type" => "Nitzsche Inc",
                        "file_size" => nil,
                        "file_data" => nil,
                        "created_at" => "2023-11-09T20:25:47.424Z",
                        "updated_at" => "2023-11-09T20:25:47.425Z"
                  }
              ]
          }
      ]
  }
  ==================================================================================================
  Benchmarking 10000 iterations
  ==================================================================================================
                                                            user     system      total        real
  URI::UID.build Hash                                  36.687913   0.130642  36.818555 ( 36.925714)
  Average                                                0.003669   0.000013   0.003682 (  0.003693)
  ..................................................................................................
                                                            user     system      total        real
  URI::UID.build Hash, include_blank: false            34.666529   0.236112  34.902641 ( 35.004841)
  Average                                                0.003467   0.000024   0.003490 (  0.003500)
  ..................................................................................................
                                                            user     system      total        real
  URI::UID.parse HASH/UID                                0.183434   0.001195   0.184629 (  0.184920)
  Average                                                0.000018   0.000000   0.000018 (  0.000018)
  ..................................................................................................
                                                            user     system      total        real
  URI::UID.decode HASH/UID                               0.312589   0.012773   0.325362 (  0.350239)
  Average                                                0.000031   0.000001   0.000033 (  0.000035)
  ..................................................................................................
                                                            user     system      total        real
  URI::UID.build ActiveRecord                           1.911902   0.015386   1.927288 (  1.930672)
  Average                                                0.000191   0.000002   0.000193 (  0.000193)
  ..................................................................................................
                                                            user     system      total        real
  URI::UID.build ActiveRecord, exclude_blank            1.930856   0.014851   1.945707 (  1.948803)
  Average                                                0.000193   0.000001   0.000195 (  0.000195)
  ..................................................................................................
                                                            user     system      total        real
  URI::UID.build ActiveRecord, include_descendants     33.488788   0.211935  33.700723 ( 33.795023)
  Average                                                0.003349   0.000021   0.003370 (  0.003380)
  ..................................................................................................
                                                            user     system      total        real
  URI::UID.parse ActiveRecord/UID                        0.119169   0.001046   0.120215 (  0.120513)
  Average                                                0.000012   0.000000   0.000012 (  0.000012)
  ..................................................................................................
                                                            user     system      total        real
  URI::UID.decode HASH/UID                               6.493185   0.031636   6.524821 (  6.555731)
  Average                                                0.000649   0.000003   0.000652 (  0.000656)
  ..................................................................................................
                                                            user     system      total        real
  UID.build.to_gid > GID.parse.find > UID.decode        2.870192   0.022088   2.892280 (  2.898905)
  Average                                                0.000287   0.000002   0.000289 (  0.000290)
  ..................................................................................................
                                                            user     system      total        real
  UID.build.to_sgid > SGID.parse.find > UID.decode      3.095248   0.024358   3.119606 (  3.126645)
  Average                                                0.000310   0.000002   0.000312 (  0.000313)
  ..................................................................................................
  ```

</details>

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
