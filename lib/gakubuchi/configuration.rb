module Gakubuchi
  class Configuration
    include ActiveSupport::Configurable

    alias_method :to_h, :config
  end
end
