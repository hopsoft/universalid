<p align="center">
  <p align="center">
    <a href="http://blog.codinghorror.com/the-best-code-is-no-code-at-all/">
      <img alt="Lines of Code" src="https://img.shields.io/badge/loc-795-47d299.svg" />
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
</p>

# Universal ID

Universal ID provides recursive serialization for Ruby objects, allowing you to transform any object to/from a URL-safe string
and enables a wide range of use-cases for your applications and scripts.

It leverages [MessagePack](https://msgpack.org/) and [Brotli](https://github.com/google/brotli) _(a combo built for speed and best-in-class data compression)_.
When combined, these libraries are up to 30% faster and within 2-5% compression rates compared to Protobuf. <a title="Source" href="https://g.co/bard/share/e5bdb17aee91">↗</a>

<!-- Tocer[start]: Auto-generated, don't remove. -->

## Table of Contents

  - [Supported Data Types](#supported-data-types)
    - [Primitives](#primitives)
    - [Composites](#composites)
    - [Extension Types](#extension-types)
    - [Custom Types](#custom-types)
  - [Options](#options)
  - [Advanced Usage](#advanced-usage)
    - [Fingerprinting](#fingerprinting)
    - [Make Copies of ActiveRecord Models](#make-copies-of-activerecord-models)
    - [ActiveRecord::Relations](#activerecordrelations)
    - [SignedGlobalID](#signedglobalid)
  - [Sponsors](#sponsors)
  - [License](#license)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

> :rocket: **Ready to Dive In?**: All the code examples below can be tested on your local machine. Just clone the repo and run `bin/console` to begin exploring. Don't forget to execute `bundle` first to ensure all dependencies are up to date. Happy coding!

## Supported Data Types

### Primitives

Universal ID supports most Ruby primitive datatypes.

- `NilClass`
- `BigDecimal`
- `Complex`
- `Date`
- `DateTime`
- `FalseClass`
- `Float`
- `Integer`
- `Range`
- `Rational`
- `Regexp`
- `String`
- `Symbol`
- `Time`
- `TrueClass`

You can use Universal ID to serialize individual primitives, but this mostly serves as the foundation for more advanced use-cases.

```ruby
uri = URI::UID.build(:demo).to_s
#=> "uid://universalid/iwKA1gBkZW1vAw#CwWAkccHf6ZTeW1ib2wD"

uid = URI::UID.parse(uri)
#=> #<URI::UID scheme=uid, host=universalid, payload=iwKA1gBkZW1vAw, fingerprint=CwWAkccHf6ZTeW1ib2wD>

uid.decode
#=> :demo
```

### Composites

Composite datatype support is where things start to get interesting.
Universal ID supports the following composite datatypes.

- `Array`
- `Hash`
- `OpenStruct`
- `Set`
- `Struct`

```ruby
array = [1, 2, 3, [:a, :b, :c, [true]]]

uri = URI::UID.build(array).to_s
#=> "uid://universalid/iweAlAECA5TUAGHUAGLUAGORwwM#iwSAkccGf6VBcnJheQM"

uid = URI::UID.parse(uri)
#=> #<URI::UID scheme=uid, host=universalid, payload=iweAlAECA5TUAGHUAGLUAGORwwM>

uid.decode
#=> [1, 2, 3, [:a, :b, :c, [true]]]

uid.decode == array
#=> true
```

```ruby
hash = {a: 1, b: 2, c: 3, array: [1, 2, 3, [:a, :b, :c, [true]]]}

uri = URI::UID.build(hash).to_s
#=> "uid://universalid/CxKAhNQAYQHUAGIC1ABjA8cFAGFycmF5lAECA5TUAGHUAGLUAGORwwM#CwS..."

uid = URI::UID.parse(uri)
#=> #<URI::UID scheme=uid, host=universalid, payload=CxKAhNQAYQHUAGIC1ABjA8cFAGFycmF5lAECA..., fingerprint=CwSAkccFf6RIYXNoAw>

uid.decode
#=> {:a=>1, :b=>2, :c=>3, :array=>[1, 2, 3, [:a, :b, :c, [true]]]}

uid.decode == hash
#=> true
```

```ruby
Book = Struct.new(:title, :author, :isbn, :published_year)
book = Book.new("The Great Gatsby", "F. Scott Fitzgerald", "9780743273565", 1925)

uri = URI::UID.build(book).to_s
#=> "uid://universalid/G2YAoGTomv9tT1ilLRgVC9vIpmuBo-k84FZ0G8-siFMBNsbW0dpBE0Tnm96..."

uid = URI::UID.parse(uri)
#=> #<URI::UID scheme=uid, host=universalid, payload=G2YAoGTomv9tT1ilLRgVC9vIpmuBo-k84FZ0G..., fingerprint=CwSAkccFf6RCb29rAw>

uid.decode
#=> #<struct Book title="The Great Gatsby", author="F. Scott Fitzgerald", isbn="9780743273565", published_year=1925>

uid.decode == book
#=> true
```

### Extension Types

The following extension datatypes ship with Universal ID.

- `ActiveRecord::Base`
- `ActiveRecord::Relation`
- `ActiveSupport::TimeWithZone`
- `GlobalID`
- `SignedGlobalID`

> :bulb: Extensions are autoloaded when the relaed datatype is detected.

**Why Universal ID with ActiveRecord?**

While ActiveRecord already supports GlobalID, a robust library for serializing individual ActiveRecord models,
Universal ID extends this functionality to cover a wider range of use cases. Here are a few reasons you may want to consider Universal ID.

- **New Records**:
  Unlike GlobalID, Universal ID can serialize models that haven't been saved to the database yet.

- **Changesets**:
  It can serialize ActiveRecord models with unsaved changes, ensuring that even transient states are captured.

- **Associations**:
  Universal ID goes beyond single models. It can include associated records, even those with unsaved changes, creating a comprehensive snapshot of complex record states.

- **Cloning**:
  Need to make a copy of a record _(including associations)_? Universal ID handles this effortlessly, making it ideal for duplicating complex datasets.

- **Control**:
  With Universal ID, you have control over the serialization process. You can precisely choose which columns to include or exclude, allowing for tailored, optimized payloads that fit your specific needs.

- **Queries/Relations**:
  Universal ID extends its capabilities to ActiveRecord relations, enabling the serialization of complex queries and scopes.

In summary, while GlobalID excels in its specific use case, Universal ID offers extended capabilities that are particularly useful in scenarios involving unsaved records, complex associations, data cloning, and database queries.

```ruby
# setup some records
campaign = Campaign.create(name: "My Campaign")
email = campaign.emails.create(subject: "First Email")
attachment = email.attachments.create(file_name: "data.pdf")

# ensure associations are loaded so they can be included in an UID
campaign.emails.load
campaign.emails.each { |e| e.attachments.load }

# make some unsaved changes
email.subject = "1st Email"

# add an unsaved record
campaign.emails.build(subject: "2nd Email")

# introspection
campaign.emails.size #=> 2
campaign.emails.loaded? #=> true
campaign.emails.last.new_record? #=> true

options = {
  include_changes: true,
  include_descendants: true,
  descendant_depth: 2
}

uri = URI::UID.build(campaign, options).to_s
#=> "uid://universalid/GxYBYGT6_Xn_OrelIDRWhQQgvbS5gQxV7EJKe3paIiEFmEEc1gLKw8Pl2-k..."

uid = URI::UID.parse(uri)
#=> #<URI::UID scheme=uid, host=universalid, payload=GxYBYGT6_Xn_OrelIDRWhQQgvbS5gQxV7EJKe..., fingerprint=CwuAkscJf6hDYW1wYWlnbtf_ReuZnGWeG5MD>

decoded = uid.decode
#=> "#<Campaign id: 13, name: \"My Campaign\" ...>

decoded == campaign
#=> true

# introspection
decoded.emails.size #=> 2
decoded.emails.loaded? #=> true
decoded.emails.first.changed? #=> true
decoded.emails.first.changes #=> {"subject"=>["First Email", "1st Email"]}
decoded.emails.last.new_record? #=> true
decoded.save #=> true
decoded.emails.last.persisted? #=> true
```

### Custom Types

Universal ID is **extensible, enabling you to register your own datatypes with custom serialization rules.
Simply convert the required data to a Ruby primitive or composite value.

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
#=> "uid://universalid/G1QAQAT-c_cO7qJcAk-TtsAiadci_IA5xoH7NV3bYttEww7xuUkzasu2HEO..."

uid = URI::UID.parse(uri)
#=> #<URI::UID scheme=uid, host=universalid, payload=G1QAQAT-c_cO7qJcAk-TtsAiadci_IA5xoH7N..., fingerprint=CwiAkccNf6xVc2VyU2V0dGluZ3MD>

uid.decode
=> #<UserSettings:0x000000011d0deb20 @preferences={:theme=>"dark", :notifications=>"email", :language=>"en", :layout=>"grid", :privacy=>"private"}, @user_id=1>
```

## Options

Universal ID supports a small, but powerful, set of options used to "prepack" the object before it's packed with Msgpack.
These options instruct Universal ID on how to prepare the object for serialization.

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
    include_changes: false

    # ......................................................................................................
    # Whether or not to include loaded in-memory descendants (i.e. child associations)
    include_descendants: false

    # ......................................................................................................
    # The max depth (number) of loaded in-memory descendants to include when `include_descendants == true`
    # For example, a value of (3) would include the following:
    #   Parent > Child > Grandchild
    descendant_depth: 0
```

Options can be applied whenever creating a UID. _Options can be passed in structured or flat format._

```ruby
hash = { a: 1, b: 2, c: 3 }

uri = URI::UID.build(hash, exclude: [:b]).to_s
#=> "uid://universalid/CwSAgtQAYQHUAGMDAw#CwSAkccFf6RIYXNoAw"

uid = URI::UID.parse(uri)
#=> #<URI::UID scheme=uid, host=universalid, payload=CwSAgtQAYQHUAGMDAw, fingerprint=CwSAkccFf6RIYXNoAw>

uid.decode
#=> {:a=>1, :c=>3}
```

It's also possible to register frequently used options.

```yaml
# app/config/changed.yml
prepack:
  include_blank: false

  database:
    include_changes: true
    include_descendants: true
    descendant_depth: 2
```

```ruby
UniversalID::Settings.register :changed, File.expand_path("app/config/changed.yml", __dir__)
uid = URI::UID.build(record, UniversalID::Settings[:changed])
```

## Advanced Usage

### Fingerprinting

Each UID is fingerprinted adds as part of the serialization process.

Fingerprints are comprised of the following components:

1. `Class (Class)`  - The encoded object's class
2. `Timestamp (Time)` - The mtime (UTC) of the file that defined the object's class

> :bulb: The timestamp or `mtime` is determined the moment a UID is created.

Fingerprints providate a simple mechanic to help manage versions of the data format...** without the need for explicit versioning**.
Whenever the class definition changes, the mtime updates, resulting in a different fingerprint.
This is especially useful in scenarios where the data format evolves over time, such as in long-lived applications.

```ruby
uid = URI::UID.build(campaign)

uid.fingerprint
#=> "CwuAkscJf6hDYW1wYWlnbtf_ReuZnGWeG5MD"

uid.fingerprint(decode: true)
#=> [Campaign(id: integer, ...), <Time>]
```

Fingerprints can help you maintain consistency and reliability when working with serialized data over time.

> :bulb: While fingerpint creation is automatic and implicit, usage is optional... ready whenever you need it.

### Make Copies of ActiveRecord Models

Make a copy of an ActiveRecord model _(with loaded associations)_.

```ruby
campaign = Campaign.first

# ensure desired associations are loaded so they can be included in an UID
campaign.emails.load
campaign.emails.each { |e| e.attachments.load }

# introspection
campaign.id #=> 1
campaign.emails.map(&:id) #=> [1, 2]
campaign.emails.map(&:attachments).flatten.map(&:id)
#=> [1, 2, 3, 4]

# setup options for copying
options = {
  include_blank: false,
  include_keys: false,
  include_timestamps: false,
  include_descendants: true,
  descendant_depth: 2
}

uri = URI::UID.build(campaign, options).to_s
#=> "uid://universalid/G7kAIBylMxZa7MouY3gUqHKkIx3hk4s8NT5xWwQsDc7lKUkGWM4DHsCxQZK..."

uid = URI::UID.parse(uri)
#=> #<URI::UID scheme=uid, host=universalid, payload=G7kAIBylMxZa7MouY3gUqHKkIx3hk4s8NT5xW..., fingerprint=CwuAkscJf6hDYW1wYWlnbtf_ReuZnGWeG5MD>

copy = uid.decode
#=> #<Campaign:0x00000001135c7448 id: nil, name: "My Campaign", description: nil, trigger: nil, created_at: nil, updated_at: nil>

copy == campaign
#=> false

# introspection
copy.new_record? #=> true
copy.id #=> nil
copy.emails.map(&:id) #=> [nil, nil]
copy.emails.map(&:attachments).flatten.map(&:id)
#=> [nil, nil, nil, nil]

# save the copy
copy.save #=> true
```

If you don't need a URL-safe UID, you can use the `Packer` directly to speed things up.

```ruby
packed = UniversalID::Packer.pack(campaign, options)
copy = UniversalID::Packer.unpack(packed)
copy.save
```

### ActiveRecord::Relations

Universal ID also supports ActiveRecord relations/scopes.
You can easily serialize complex queries into a portable and sharable format.

> :bulb: Universal ID clears cached data within the relation before encoding. This minimizes payload size while preserving the integrity of the underlying query.

```ruby
relation = Campaign.joins(:emails).where("emails.subject LIKE ?", "Flash Sale%")

uri = URI::UID.build(relation).to_s
#=> "uid://universalid/G90EQCwLeEP1oQtHFksrdN5YS4ju5TryFZwBJgh2toqS3SKEVSl1FoNtZjI..."

uid = URI::UID.parse(encoded)
#=> #<URI::UID scheme=uid, host=universalid, payload=G90EQCwLeEP1oQtHFksrdN5YS4ju5TryFZwBJ..., fingerprint=CxKAkscXf7ZBY3RpdmVSZWNvcmQ6OlJlbGF0a...>

decoded = uid.decode

# introspection
decoded == relation #=> true
decoded.is_a? ActiveRecord::Relation #=> true
decoded.loaded? #=> false

# run the query
campaigns = decoded.load
```

### SignedGlobalID

Features like `signing` _(to prevent tampering)_, `purpose`, and `expiration` are provided by SignedGlobalIDs.
These features _(and more)_ will eventually be added to Universal ID, but until then...
simply convert your UID to a SignedGlobalID to add these features to any Universal ID.

```ruby
data = OpenStruct.new(name: "Demo", value: "Example")

sgid = URI::UID.build(data).to_sgid_param(for: "purpose", expires_in: 1.hour)
#=> "eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJZ0plQTJkcFpEb3ZMM1Z1YVhabGNuTmhiQzFwWkM5V..."

uid = URI::UID.from_sgid(sgid, for: "purpose")
#=> #<URI::UID scheme=uid, host=universalid, payload=Cw-Axxx-gtYAbmFtZaREZW1vxwUAdmFsdWWnR..., fingerprint=ixqAkscof9kmVW5pdmVyc2FsSUQ6OkV4dGVuc...>

decoded = uid.decode
#=> #<OpenStruct name="Demo", value="Example">

# a mismatched purpose returns nil... as expected
URI::UID.from_sgid(sgid, for: "mismatch")
#=> nil
```

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
