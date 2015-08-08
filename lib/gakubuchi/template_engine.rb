module Gakubuchi
  class TemplateEngine
    extend ::Forwardable

    attr_reader :klass
    alias_method :engine, :klass

    def_delegators 'Rails.application', :assets
    def_delegators 'Sprockets::Utils', :normalize_extension
    private :assets, :normalize_extension

    def initialize(engine)
      const = engine.to_s.constantize
      raise TypeError, "#{const} is not a class" unless const.is_a?(Class)

      @klass = const
    end

    def register!(extname)
      return false if registered?(extname)
      !!assets.register_engine(extname, engine)
    end

    def registered?(extname)
      assets.engines[normalize_extension(extname)] == engine
    end
  end
end
