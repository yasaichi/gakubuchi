module Gakubuchi
  class Railtie < ::Rails::Railtie
    initializer 'gakubuchi.assets.precompile' do
      TemplateEngine.new('Slim::Template').register!('.slim')
      TemplateEngine.new('Tilt::HamlTemplate').register!('.haml')
    end

    rake_tasks do
      ::Dir.glob(::File.expand_path('../../tasks/*.rake', __FILE__)).each { |path| load path }
    end
  end
end
