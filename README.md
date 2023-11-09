<p align="center">
  <h1 align="center">Universal ID 🌌</h1>
  <p align="center">
    <a href="http://blog.codinghorror.com/the-best-code-is-no-code-at-all/">
      <img alt="Lines of Code" src="https://img.shields.io/badge/loc-612-47d299.svg" />
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
  <h2 align="center">Introducing the UniversalID Gem: The Future of Object Portability in Rails!</h2>
  <h3 align="center">Simple, standardized, secure marshaling</h3>
</p>

---

__**Why UniversalID?**__ For the modern Rails developer aiming to streamline processes, ensure data flexibility, and elevate their toolkit.
__Discover the potential, and make your Rails applications more powerful than ever!__

---

:white_check_mark: **Instant Portability**: Make ANY object effortlessly portable across process boundaries by including one module and implementing a single method!

:white_check_mark: **Small Payload**: Reduced payload size ensures effortless sharing of objects in URLs, browser cookies, local storage, or any desired location, stress-free.

:white_check_mark: **Deep Marshaling**: Implicitly marshal embedded objects that implement GlobalID, even when they're deeply nested inside your data structure.

:white_check_mark: **ActiveRecord Support**: Unsaved changes? New records? Child records? UniversalID has got you covered.

:white_check_mark: **Limitless Use Cases**: From hassle-free multi-step forms to implicit marhsaling of CurrentAttributes for ActiveJobs/Sidekiq Workers - the sky's the limit!

:white_check_mark: **Simple Data Migration**: Transfer large subsets of data between fragmented datastores without centralized/tempoary storage - just marshal, pass, and unmarshal!

:white_check_mark: **Secure Your Data**: Since UniversalID conforms to the GlobalID protocol, utilize security features from SignedGlobalID, like 'purpose' and 'expiration'.

:white_check_mark: **Self-Contained Digital Products**: Pave the way for innovative digital product creation.

<!-- Tocer[start]: Auto-generated, don't remove. -->

## Table of Contents

  - [What is Global ID?](#what-is-global-id)
    - [Global ID Examples](#global-id-examples)
  - [What is Universal ID?](#what-is-universal-id)
    - [Why Expand Global ID?](#why-expand-global-id)
    - [Summary of Benefits](#summary-of-benefits)
      - [GlobalID](#globalid)
      - [SignedGlobalID](#signedglobalid)
    - [Hash](#hash)
    - [ActiveModel](#activemodel)
    - [Running Tests, Benchmarks, and the Demo](#running-tests-benchmarks-and-the-demo)
    - [Benchmarks](#benchmarks)
  - [License](#license)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

## Sponsors

<p align="center">
  <em>Proudly sponsored by</em>
</p>
<p align="center">
  <a href="https://www.clickfunnels.com?utm_source=hopsoft&utm_medium=open-source&utm_campaign=universalid">
    <img src="https://images.clickfunnel.com/uploads/digital_asset/file/176632/clickfunnels-dark-logo.svg" width="575" />
  </a>
</p>

## What is Global ID?

A GlobalID is an URI that uniquely identifies an ActiveRecord instance.
It was designed to make ActiveRecord models portable across process boundaries.
For example, passing a model instance as an argument _(from the web server)_ to a background job.
They also facilitate use-cases like interleaved search results that mix multiple classes into a single unified list.

GlobalIDs can also be [signed](https://github.com/rails/globalid#signed-global-ids) and dedicated to a
[purpose](https://github.com/rails/globalid#signed-global-ids) with an [expiration](https://github.com/rails/globalid#signed-global-ids) policy.

### Global ID Examples

```ruby
# Basic GlobalIDs
campaign = Campaign.create(name: "Example")
campaign.to_gid #............ #<GlobalID:0x000... @uri=#<URI::GID gid://UniversalID/Campaign/1>>
campaign.to_gid.uri #........ #<URI::GID gid://UniversalID/Campaign/1>
campaign.to_gid.to_s #....... gid://UniversalID/Campaign/1
campaign.to_gid_param #...... Z2lkOi8vVW5pdmVyc2FsSUQvQ2FtcGFpZ24vMQ

gid = GlobalID.parse("Z2lkOi8vVW5pdmVyc2FsSUQvQ2FtcGFpZ24vMQ") # #<GlobalID:0x000... @uri=#<URI::GID gid://UniversalID/Campaign/1>>
campaign == gid.find # true
```

```ruby
# Signed GlobalIDs
campaign = Campaign.create(name: "Example")
campaign.to_sgid #......... #<SignedGlobalID:0x000... @expires_at=nil, @purpose="...", @uri=#<URI::GID gid://UniversalID/Campaign/1>, ...>
campaign.to_sgid_param #... BAh7CEkiCGdpZAY6BkVUSSIhZ2lkOi8vVW...

sgid = SignedGlobalID.parse("BAh7CEkiCGdpZAY6BkVUSSIhZ2lkOi8vVW...") # #<SignedGlobalID:0x000... @expires_at=nil, @purpose="...", @uri=#<URI::GID gid://UniversalID/Campaign/1>
campaign == sgid.find # true
```

## What is Universal ID?

UniversalID extends GlobalID functionality to more objects.

- Array
- Hash
- ActiveRecord _(saved, unsaved, or with unsaved changes)_
- ActiveRecord::Relation
- etc.

### Why Expand Global ID?

A variety of additional use-cases can be handled easily _(with minimal code)_ by extending GlobalID to support unsaved ActiveRecords and other objects like Hash.
Consider a multi-step form or wizard where users incrementally build up a complex set of related ActiveRecord instances.

- When do we save to the database?
- What about validations? Will they be a problem if we save early?
- Should we persist the data in cache instead?
- What if the user abandons the process?
- How do we cleanup abandoned data?
- Should we consider full-stack-frontend to manage state client side before saving? 😱

**Don't fret!** UniversalID supports safely marshaling unsaved ActiveRecords between steps.

```ruby
# 1. Start multi-step form (partial data)
campaign = Campaign.new(name: "Example") #....... unsaved data
param = campaign.to_portable_hash_sgid_param #... make it portable (assign this to a hidden field, querystring etc.)

# HTTP request / crossing a process boundary / etc.

# Step 2. Continue multi-step form (enrich partial data)
campaign = Campaign.new_from_portable_hash(param) #................................... unsaved data
campaign.emails << campaign.emails.build(subject: "First Email", body: "Welcome") #... unsaved data
param = campaign.to_portable_hash_sgid_param #........................................ make it portable

# HTTP request / crossing a process boundary / etc.

# Step 3-N. Continue multi-step form (enrich partial data)
# ...

# Final Step. Save the data
campaign = Campaign.new_from_portable_hash(param)
campaign.save!
```

**And... this is just one use-case!**

UniversalID can be used to solve a multitude of problems with minimal effort.

- Sharable artifacts (reports, configurations, etc.)
- Data versioning
- Digital products
- Marshaling Current::Attributes for use in background jobs
- etc. *the only limit is your imagination*

### Summary of Benefits

#### GlobalID

- Standardizes marshaling _(fewer bespoke solutions)_
- Reduces complexity and lines-of-code
- Simplifies derivative works _(works with existing data-models/object-structures)_
- Encapsulates portability across processes and systems _(self-contained)_
- Creates opportunity for generic solutions _(meta-programming)_
- Minimizes data storage needs for incomplete or ephemeral data _(URL safe string)_
- Facilitates easy rollback when incomplete or ephemeral data is abandoned

#### SignedGlobalID

- Enhances security _(can't be tampered with, prevents MITM attacks, etc.)_
- Provides scoping for a specific purpose _(via `for`)_
- Supports versioning _(via purpose)_
- Includes scarcity _(via expiration)_
- Enables productization _(an SGID string is a digital "product")_

### Hash

```ruby
hash = {name: "Example", list: [1,2,3], object: {nested: true}}
portable = UniversalID::PortableHash.new(hash)
gid_param = portable.to_gid_param #..... Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBvcnRhYmxlSGFzaC9lTnFyVnNwTHpFMVZzbEp5clVqTUxj...
sgid_param = portable.to_sgid_param #... BAh7CEkiCGdpZAY6BkVUSSIBg2dpZDovL1VuaXZlcnNhbElEL1VuaXZlcnNhbElEOjpQb3J0YWJsZUhhc2gvZU5x...


UniversalID::PortableHash.parse_gid(gid_param).find
{"name"=>"Example", "list"=>[1, 2, 3], "object"=>{"nested"=>true}}


UniversalID::PortableHash.parse_gid(sgid_param).find
{"name"=>"Example", "list"=>[1, 2, 3], "object"=>{"nested"=>true}}
```

### ActiveModel

```ruby
email = Email.new(subject: "Example", body: "Hi there...") # unsaved
gid = email.to_portable_hash_gid_param #..... Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBvcnRhYmxlSGFzaC9lTnFyVmlvdVRjcEtUUz...
sgid = email.to_portable_hash_sgid_param #... BAh7CEkiCGdpZAY6BkVUSSJzZ2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBvcnRhYmxlSG...

copy = Email.new_from_portable_hash(gid)
signed_copy = Email.new_from_portable_hash(sgid)

email.save!

options = {portable_hash_options: {except: [:id, :created_at, :updated_at]}}
# NOTE: Options can be configured globally via UniversalID.config.portable_hash

gid = email.to_portable_hash_gid_param(options)
sgid = email.to_portable_hash_gid_param(options)

# Copies are new records and don't include values for id, created_at, or updated_at
copy = Email.new_from_portable_hash(gid)
signed_copy = Email.new_from_portable_hash(sgid)
```

### Deeply Nested GlobalIDs

UniversalID implicitly handles deeply nested objects that implement GlobalID.

```rb
campaign = Campaign.create(name: "Example Campaign", description: "Example Description", trigger: "Example Trigger")
portable = UniversalID::PortableHash.new({name: "Example", list: [1,2,3], object: {nested: true}, campaign: campaign})

gid_param = portable.to_gid_param #..... Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBvcnRhYmxlSGFzaC...
sgid_param = portable.to_sgid_param #... eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJZ0hFWjJsa09pOHZWVzVwZG...

UniversalID::PortableHash.parse_gid(gid_param).find
{name: "Example", list: [1,2,3], object: {nested: true}, campaign: <Campaign id: ...>}}


UniversalID::PortableHash.parse_gid(sgid_param).find
{"name"=>"Example", "list"=>[1, 2, 3], "object"=>{"nested"=>true, campaign: <Campaign id: ...>}}
```

### Running Tests, Benchmarks, and the Demo

```
git clone https://github.com/hopsoft/universalid.git
cd universalid

bundle
rake test
bin/benchmarks
bin/demo
```

### Benchmarks

```
Model Name: MacBook Air
Chip: Apple M1
Total Number of Cores: 8 (4 performance and 4 efficiency)
Memory: 16 GB

--------------------------------------------------------------------------------------------------

# Simple Campaign with 3 associated Email records (nested attributes)

..................................................................................................
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
