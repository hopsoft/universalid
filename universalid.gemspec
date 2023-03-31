# frozen_string_literal: true

require_relative "lib/universal_id/version"

Gem::Specification.new do |s|
  s.name = "universalid"
  s.version = UniversalID::VERSION
  s.authors = ["Nate Hopkins (hopsoft)"]
  s.email = ["natehop@gmail.com"]

  s.summary = "Identify anything that implements GlobalID across systems with a URI"
  s.description = <<~DESC
    Expands GlobalID to unpersisted ActiveModels, ActiveRecord::Relations, and anything that implements GlobalID.
  DESC

  s.homepage = "https://github.com/hopsoft/universalid"
  s.license = "MIT"
  s.required_ruby_version = ">= 2.7.5"

  s.metadata["homepage_uri"] = s.homepage
  s.metadata["source_code_uri"] = s.homepage
  s.metadata["changelog_uri"] = s.homepage + "/blob/main/CHANGELOG.md"

  s.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  s.require_paths = ["lib"]

  s.add_dependency "globalid", ">= 1.1"

  s.add_development_dependency "activerecord"
  s.add_development_dependency "activesupport"
  s.add_development_dependency "faker"
  s.add_development_dependency "magic_frozen_string_literal"
  s.add_development_dependency "minitest-reporters"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "pry-doc"
  s.add_development_dependency "rake"
  s.add_development_dependency "sequel"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "standard"
  s.add_development_dependency "tocer"
end
