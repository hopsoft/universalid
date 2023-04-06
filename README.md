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
                                                               user       system     total      real
Hash to PortableHash (1k times)                                0.015499   0.000180   0.015679   0.015680
PortableHash ID (1k times)                                     0.034924   0.000170   0.035094   0.035097
PortableHash find ID (1k times)                                0.006215   0.000455   0.006670   0.006671
PortableHash to GID (1k times)                                 0.043284   0.000316   0.043600   0.043603
PortableHash to SGID (1k times)                                0.043085   0.000466   0.043551   0.043556
GlobalID parse + find PortableHash GID param (1k times)        0.024027   0.000485   0.024512   0.024516
SignedGlobalID parse + find PortableHash SGID param (1k times) 0.028170   0.000433   0.028603   0.028639
ActiveModel to param (1k times)                                0.085547   0.000495   0.086042   0.086043
ActiveModel to signed param (1k times)                         0.092129   0.000807   0.092936   0.092943
ActiveModel from param (1k times)                              0.300829   0.001478   0.302307   0.302347
ActiveModel from signed param (1k times)                       0.318139   0.000835   0.318974   0.319004
```
