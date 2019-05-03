$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gakubuchi/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gakubuchi"
  s.version     = Gakubuchi::VERSION
  s.authors     = ["yasaichi"]
  s.email       = ["yasaichi@users.noreply.github.com"]
  s.homepage    = "https://github.com/yasaichi/gakubuchi"
  s.summary     = "Static pages management with Asset Pipeline"
  s.description = "Gakubuchi provides a simple way to manage static pages with Asset Pipeline."
  s.license     = "MIT"

  s.required_ruby_version = ">= 2.0.0"
  s.files = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "grease", "~> 0.3.0"
  s.add_dependency "railties", ">= 4.0.0"
  s.add_dependency "sprockets-rails", ">= 2.0.0"

  s.add_development_dependency "ammeter", ">= 1.0.0"
  s.add_development_dependency "appraisal", ">= 2.0.0"
  s.add_development_dependency "codeclimate-test-reporter", "~> 1.0"
  s.add_development_dependency "haml-rails"
  s.add_development_dependency "reek"
  s.add_development_dependency "rspec-its"
  s.add_development_dependency "rspec-rails", ">= 3.0.1"
  s.add_development_dependency "rubocop", "< 0.51.0"
  s.add_development_dependency "simplecov"
  # TODO: Deal with the bugs on the latest version of slim-rails
  s.add_development_dependency "slim-rails", "< 3.1.1"
  s.add_development_dependency "sqlite3"
end
