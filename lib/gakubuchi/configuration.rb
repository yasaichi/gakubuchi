module Gakubuchi
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
