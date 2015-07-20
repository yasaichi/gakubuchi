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
  s.description = "Gakubuchi enables you to manage static pages with Asset Pipeline"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 4.0.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", ">= 3.0.1"
  s.add_development_dependency "ammeter", ">= 1.0.0"
  s.add_development_dependency "codeclimate-test-reporter"
  s.add_development_dependency "pry-byebug"
end
