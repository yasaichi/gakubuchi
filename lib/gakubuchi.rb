require "gakubuchi/configuration"
require "gakubuchi/error"
require "gakubuchi/fileutils"
require "gakubuchi/mime_type"
require "gakubuchi/task"
require "gakubuchi/version"

if defined?(::Rails::Railtie) && defined?(::Sprockets::Railtie)
  require "gakubuchi/engine_registrar"
  require "gakubuchi/railtie"
  require "gakubuchi/template"
end
