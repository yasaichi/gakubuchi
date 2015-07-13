$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gakubuchi/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gakubuchi"
  s.version     = Gakubuchi::VERSION
  s.authors     = ["yasaichi"]
  s.email       = ["yasaichi@users.noreply.github.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Gakubuchi."
  s.description = "TODO: Description of Gakubuchi."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 4.2.3"

  s.add_development_dependency "sqlite3"
end
