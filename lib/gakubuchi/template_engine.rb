module Gakubuchi
  class TemplateEngine
    extend ::Forwardable

    attr_reader :klass
    alias_method :engine, :klass

    def_delegators 'Rails.application', :assets
    def_delegators 'Sprockets::Utils', :normalize_extension
    private :assets, :normalize_extension

    def initialize(engine)
      @klass = engine.to_s.constantize rescue nil
    end

    def register!(extname)
      if engine.instance_of?(Class) && !registered?(extname)
        !!assets.register_engine(extname, engine)
      else
        false
      end
    end

    def registered?(extname)
      assets.engines[normalize_extension(extname)] == engine
    end
  end
end
