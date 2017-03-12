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

module Gakubuchi
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= ::Gakubuchi::Configuration.new
    end

    def configure
      yield(configuration) if block_given?
    end

    def reset
      @configuration = nil
    end
  end
end
