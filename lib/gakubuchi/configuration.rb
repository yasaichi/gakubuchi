# frozen_string_literal: true
require "active_support/configurable"
require "forwardable"

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

  class Configuration
    extend ::Forwardable
    include ::ActiveSupport::Configurable

    private :config
    def_delegator :config, :to_h

    config_accessor :leave_digest_named_templates do
      false
    end

    config_accessor :template_directory do
      "templates"
    end
  end
end
