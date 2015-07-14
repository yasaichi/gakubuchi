module Gakubuchi
  class Engine < ::Rails::Engine
    isolate_namespace Gakubuchi

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
