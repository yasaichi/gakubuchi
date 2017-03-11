module VersionHelpers
  module_function

  def major_version_of(mod)
    Gem::Version.new(mod::VERSION).segments.first
  end
end
