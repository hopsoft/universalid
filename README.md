<p align="center">
  <h1 align="center">Universal ID 🌌</h1>
  <p align="center">
    <a href="http://blog.codinghorror.com/the-best-code-is-no-code-at-all/">
      <img alt="Lines of Code" src="https://img.shields.io/badge/loc-166-47d299.svg" />
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

- Standardized marshaling vs bespoke solutions
- Simplified implementations (templating on top of existing data model or object structure)
- Enables meta-programmed generic solutions
- Fully Encapsulated portability across process boundaries and even disparate systems
- Simplifies concerns like where to persist partial ephemeral data (database, redis, cache, cookie, session, etc..)
- Eliminates the need to rollback any persisted partial ephemeral data when workflow is abandoned

### SignedGlobalID

- Enhanced Security (prevent MITM attacks etc.)
- Scoped to optional purpose (i.e. `for`)
- Versioning via purpose
- Scarcity via optional expiration
- Easy to productize and sell

## Performance

NOTE: Performance should be contrasted with alternative approaches like saving saving to cache, database, etc.

```
# Simple Campaign with 3 associated Email records (nested attributes)
                                              user     system      total        real
Marshal to SignedGlobalID                    0.000282   0.000025   0.000307 (  0.000306)
Marshal from SignedGlobalID                  0.000690   0.000213   0.000903 (  0.001048)
Marshal to SignedGlobalID (1k iterations)    0.091259   0.000654   0.091913 (  0.092025)
Marshal from SignedGlobalID (1k iterations)  0.028291   0.000670   0.028961 (  0.028985)
```
