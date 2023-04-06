<p align="center">
  <h1 align="center">Universal ID 🌌</h1>
  <p align="center">
    <a href="http://blog.codinghorror.com/the-best-code-is-no-code-at-all/">
      <img alt="Lines of Code" src="https://img.shields.io/badge/loc-144-47d299.svg" />
    </a>
    <a href="https://codeclimate.com/github/hopsoft/universalid/maintainability">
      <img src="https://api.codeclimate.com/v1/badges/80bcd3acced072534a3a/maintainability" />
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
  <h2 align="center">Standardized portability for unsaved ActiveRecords</h2>
  <h3 align="center">Expands GlobalID support to objects like Hash, ActiveRecord::Relation, and more</h3>
</p>

## Sponsors

<p align="center">
  <em>Proudly sponsored by</em>
</p>
<p align="center">
  <a href="https://www.clickfunnels.com?utm_source=hopsoft&utm_medium=open-source&utm_campaign=universalid">
    <img src="https://images.clickfunnel.com/uploads/digital_asset/file/176632/clickfunnels-dark-logo.svg" width="575" />
  </a>
</p>

TODO: write docs...

## Why?

### GlobalID

- Standardizes marshaling _(no more bespoke solutions)_
- Reduces complexity and total Lines-Of-Code
- Simplifies derivative works _(works with existing data-models/object-structures)_
- Encapsulates portability across processes and systems _(self-contained)_
- Creates opportunity for generic solutions _(meta-programming)_
- Minimizes data storage needs for incomplete or ephemeral data _(URL safe string)_
- Facilitates easy rollback when incomplete or ephemeral data is abandoned

### SignedGlobalID

- Enhances security _(can't be tampered with, prevents MITM attacks, etc.)_
- Provides scoping for a specific purpose _(via `for`)_
- Supports versioning _(via purpose)_
- Includes scarcity _(via expiration)_
- Enables productization _(an SGID string is a digital "product")_

## UniversalID Objects

### Hash

### ActiveModel

### Benchmarks

```
# Simple Campaign with 3 associated Email records (nested attributes)
==================================================================================================
Benchmarking 10000 iterations
==================================================================================================
                                                           user     system      total        real
PortableHash.new                                       0.194428   0.000358   0.194786 (  0.194788)
Average                                                0.000019   0.000000   0.000019 (  0.000019)
..................................................................................................
                                                           user     system      total        real
PortableHash.new w/ options                            0.191249   0.000421   0.191670 (  0.191677)
Average                                                0.000019   0.000000   0.000019 (  0.000019)
..................................................................................................
                                                           user     system      total        real
PortableHash.find                                      0.061181   0.002219   0.063400 (  0.063401)
Average                                                0.000006   0.000000   0.000006 (  0.000006)
..................................................................................................
                                                           user     system      total        real
PortableHash#id                                        0.342809   0.001674   0.344483 (  0.344494)
Average                                                0.000034   0.000000   0.000034 (  0.000034)
..................................................................................................
                                                           user     system      total        real
PortableHash#to_gid                                    0.422914   0.001586   0.424500 (  0.424498)
Average                                                0.000042   0.000000   0.000042 (  0.000042)
..................................................................................................
                                                           user     system      total        real
PortableHash#to_gid_param                              0.437669   0.001826   0.439495 (  0.439509)
Average                                                0.000044   0.000000   0.000044 (  0.000044)
..................................................................................................
                                                           user     system      total        real
PortableHash#to_sgid                                   0.430941   0.002055   0.432996 (  0.433020)
Average                                                0.000043   0.000000   0.000043 (  0.000043)
..................................................................................................
                                                           user     system      total        real
PortableHash#to_sgid_param                             0.492965   0.001968   0.494933 (  0.494978)
Average                                                0.000049   0.000000   0.000049 (  0.000049)
..................................................................................................
                                                           user     system      total        real
ActiveModelSerializer.new_from_portable_hash           3.009667   0.006939   3.016606 (  3.017388)
Average                                                0.000301   0.000001   0.000302 (  0.000302)
..................................................................................................
                                                           user     system      total        real
ActiveModelSerializer.new_from_portable_hash (signed)  3.189282   0.006650   3.195932 (  3.196076)
Average                                                0.000319   0.000001   0.000320 (  0.000320)
..................................................................................................
                                                           user     system      total        real
ActiveModelSerializer#to_portable_hash_gid_param       0.923773   0.002653   0.926426 (  0.926427)
Average                                                0.000092   0.000000   0.000093 (  0.000093)
..................................................................................................
                                                           user     system      total        real
ActiveModelSerializer#to_portable_hash_sgid_param      0.991336   0.002782   0.994118 (  0.994133)
Average                                                0.000099   0.000000   0.000099 (  0.000099)
..................................................................................................
```
