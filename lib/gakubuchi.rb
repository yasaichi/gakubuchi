require 'gakubuchi/configuration'
require 'gakubuchi/version'
require 'gakubuchi/engine' if defined?(Rails)

module Gakubuchi
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration) if block_given?
    end
  end
end
