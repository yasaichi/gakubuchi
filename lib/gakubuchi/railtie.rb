# frozen_string_literal: true
require "gakubuchi/engine_registrar"
require "gakubuchi/mime_type"
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
      ::Dir.glob(::File.expand_path("../../tasks/*.rake", __FILE__)).each { |path| load path }
    end
  end
end
