# frozen_string_literal: true
require "gakubuchi/configuration"
require "gakubuchi/task"

module Gakubuchi
  class RakeTask
    attr_reader :application, :templates
    attr_accessor :configuration

    def self.enhance(application, &block)
      new(application).tap do |rake_task|
        yield(rake_task) if block_given?
        rake_task.enhance
      end
    end

    def initialize(application)
      @application = application
      @configuration = ::Gakubuchi::Configuration.new
      @templates = []
    end

    def enhance
      application["assets:precompile"].enhance { task.publish(templates) }
      application["assets:clobber"].enhance { task.remove(templates) }
    end

    def task
      ::Gakubuchi::Task.new(configuration)
    end

    def templates=(templates)
      @templates = Array(templates)
    end
  end
end
