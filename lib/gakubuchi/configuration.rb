module Gakubuchi
  class Configuration
    extend ::Forwardable
    include ::ActiveSupport::Configurable

    private :config
    def_delegators :config, :to_h

    config_accessor :remove_precompiled_templates do
      true
    end

    config_accessor :template_directory do
      'templates'
    end
  end
end
