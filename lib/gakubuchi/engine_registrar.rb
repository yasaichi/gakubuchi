module Gakubuchi
  class EngineRegistrar
    def initialize(env)
      @env = env
    end

    def register(target, engine)
      klass = constantize(engine)
      return false if !klass.instance_of?(::Class) || registered?(target)

      args = [target, klass]
      args << { silence_deprecation: true } if Sprockets::VERSION.start_with?("3")

      @env.register_engine(*args)
      true
    end

    def registered?(target)
      @env.engines.key?(::Sprockets::Utils.normalize_extension(target))
    end

    private

    def constantize(klass)
      klass.to_s.constantize
    rescue ::LoadError, ::NameError
      nil
    end
  end
end
