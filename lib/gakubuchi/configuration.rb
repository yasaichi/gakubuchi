module Gakubuchi
  class Configuration
    include ::ActiveSupport::Configurable
    alias_method :to_h, :config

    config_accessor :remove_precompiled_templates do
      true
    end

    config_accessor :template_root do
      'app/assets/templates'
    end
  end
end
