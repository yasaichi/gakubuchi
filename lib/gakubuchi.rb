require "fileutils"
require "forwardable"
require "logger"
require "active_support/configurable"

require "gakubuchi/configuration"
require "gakubuchi/error"
require "gakubuchi/fileutils"
require "gakubuchi/task"
require "gakubuchi/version"

if defined?(::Rails::Railtie) && defined?(::Sprockets::Railtie)
  require "pathname"
  require "gakubuchi/engine_registrar"
  require "gakubuchi/template"
  require "gakubuchi/railtie"
  require "gakubuchi/public_exceptions"
end

module Gakubuchi
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration) if block_given?
    end

    def reset
      @configuration = nil
    end
  end
end
