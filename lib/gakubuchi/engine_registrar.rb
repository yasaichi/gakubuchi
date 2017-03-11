require "active_support/inflector"
require "grease"
require "sprockets"

module Gakubuchi
  class EngineRegistrar
    EXTENSION_WITH_SIGLE_DOT = /\A\.[^\.]+\z/

    def initialize(env)
      @env = env
    end

    def register(mime_type, engine_name_or_class)
      engine = constantize(engine_name_or_class)
      return false if !engine.instance_of?(::Class) || mime_type.extensions.empty?

      if sprockets_major_version >= 4
        register_as_transformer(mime_type, engine)
      else
        register_as_engine(mime_type, engine)
      end

      true
    end

    private

    def constantize(constant_name)
      constant_name.to_s.constantize
    rescue ::LoadError, ::NameError
      nil
    end

    def sprockets_major_version
      @sprockets_major_version ||= ::Gem::Version.new(::Sprockets::VERSION).segments.first
    end

    def register_as_engine(mime_type, engine)
      mime_type.extensions.select { |ext| ext =~ EXTENSION_WITH_SIGLE_DOT }.each do |ext|
        args = [ext, engine]
        args << { silence_deprecation: true } if sprockets_major_version == 3
        @env.register_engine(*args)
      end
    end

    def register_as_transformer(mime_type, engine)
      content_type = mime_type.content_type

      @env.register_mime_type(content_type, extensions: mime_type.extensions)
      @env.register_transformer(content_type, engine.default_mime_type, ::Grease.apply(engine))
    end
  end
end
