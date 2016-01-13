module Gakubuchi
  class Railtie < ::Rails::Railtie
    config.assets.configure do |env|
      engine_registrar = EngineRegistrar.new(env)

      engine_registrar.register(:haml, '::Tilt::HamlTemplate')
      engine_registrar.register(:slim, '::Slim::Template')
    end

    rake_tasks do
      ::Dir.glob(::File.expand_path('../../tasks/*.rake', __FILE__)).each { |path| load path }
    end
  end
end
