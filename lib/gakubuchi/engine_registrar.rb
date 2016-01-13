module Gakubuchi
  class EngineRegistrar
    def initialize(env)
      @env = env
    end

    def register(target, engine)
      klass = constantize(engine)
      return false if !klass.instance_of?(::Class) || registered?(target)

      @env.register_engine(target, klass)
      true
    end

    def registered?(target)
      @env.engines.key?(::Sprockets::Utils.normalize_extension(target))
    end

    private

    def constantize(klass)
      klass.to_s.constantize
    rescue ::NameError
      nil
    end
  end
end
