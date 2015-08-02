module Gakubuchi
  class Engine < ::Rails::Engine
    isolate_namespace Gakubuchi

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'gakubuchi.assets.precompile' do |app|
      TemplateEngine.new('Slim::Template').register!('.slim')
      TemplateEngine.new('Tilt::HamlTemplate').register!('.haml')
    end
  end
end
