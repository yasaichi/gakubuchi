require 'rails'

require 'gakubuchi/configuration'
require 'gakubuchi/task'
require 'gakubuchi/template'
require 'gakubuchi/version'
require 'gakubuchi/engine'

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
