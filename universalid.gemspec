# frozen_string_literal: true

require_relative "lib/universal_id/version"

Gem::Specification.new do |s|
  s.name = "universalid"
  s.version = UniversalID::VERSION
  s.authors = ["Nate Hopkins (hopsoft)"]
  s.email = ["natehop@gmail.com"]

  s.summary = "URL-Safe String Serialization for any Ruby Object"
  s.description = <<~DESC
    Universal ID is a Ruby library that specializes in the serialization of Ruby objects to URL-safe strings,
    employing MessagePack and Brotli for optimized encoding. It facilitates efficient data transfer and state
    management across various computing processes. Designed to seamlessly integrate with Ruby applications,
    it does not rely on Rails-specific dependencies, making it adaptable for diverse Ruby projects.
  DESC

  s.homepage = "https://github.com/hopsoft/universalid"
  s.license = "MIT"
  s.required_ruby_version = ">= 3.0"

  s.metadata["homepage_uri"] = s.homepage
  s.metadata["source_code_uri"] = s.homepage
  s.metadata["changelog_uri"] = s.homepage + "/blob/main/CHANGELOG.md"

  s.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  s.require_paths = ["lib"]

  s.add_dependency "brotli", ">= 0.4"
  s.add_dependency "msgpack", ">= 1.7"
  s.add_dependency "config", ">= 5.0"

  s.add_development_dependency "activerecord"
  s.add_development_dependency "activesupport"
  s.add_development_dependency "actionview"
  s.add_development_dependency "awesome_print"
  s.add_development_dependency "faker"
  s.add_development_dependency "globalid", ">= 1.1"
  s.add_development_dependency "magic_frozen_string_literal"
  s.add_development_dependency "minitest-reporters"
  s.add_development_dependency "model_probe"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "pry-doc"
  s.add_development_dependency "rainbow"
  s.add_development_dependency "rake"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "standard", ">= 1.32"
end
