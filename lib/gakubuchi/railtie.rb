# frozen_string_literal: true
require "gakubuchi/configuration"
require "gakubuchi/engine_registrar"
require "gakubuchi/mime_type"
require "gakubuchi/rake_task"
require "gakubuchi/template"
require "rails/railtie"
require "sprockets/railtie"

module Gakubuchi
  class Railtie < ::Rails::Railtie
    config.assets.configure do |env|
      engine_registrar = ::Gakubuchi::EngineRegistrar.new(env)

      haml = ::Gakubuchi::MimeType.new("text/haml", extensions: %w(.haml .html.haml))
      engine_registrar.register(haml, "Tilt::HamlTemplate")

      slim = ::Gakubuchi::MimeType.new("text/slim", extensions: %w(.slim .html.slim))
      engine_registrar.register(slim, "Slim::Template")
    end

    config.after_initialize do
      # NOTE: Call #to_s for Sprockets 4 or later
      templates = ::Gakubuchi::Template.all.map { |template| template.logical_path.to_s }
      config.assets.precompile += templates
    end

    rake_tasks do
      ::Gakubuchi::RakeTask.enhance(::Rake.application) do |task|
        task.configuration = ::Gakubuchi.configuration
        task.templates = ::Gakubuchi::Template.all
      end
    end
  end
end
