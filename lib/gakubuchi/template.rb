module Gakubuchi
  class Template
    extend ::Forwardable

    attr_reader :pathname
    def_delegators :@pathname, :hash

    %w(== === eql?).each do |method_name|
      define_method(method_name) do |other|
        self.class == other.class && @pathname.__send__(method_name, other.pathname)
      end
    end

    def self.all
      ::Dir.glob(root.join('**/*.html*')).map { |path| new(path) }
    end

    def self.root
      ::Rails.root.join('app/assets', Gakubuchi.configuration.template_directory)
    end

    def initialize(path)
      @pathname = ::Pathname.new(path)
    end

    def destination_pathname
      dirname = relative_pathname.dirname
      ::Rails.public_path.join(dirname, "#{relative_pathname.basename(extname)}.html")
    end

    def extname
      extnames = []
      basename_without_ext = pathname.basename

      loop do
        extname = basename_without_ext.extname
        break if extname.empty?

        extnames.unshift(extname)
        basename_without_ext = basename_without_ext.basename(extname)
      end

      extnames.join
    end

    def precompiled_pathname
      asset = ::Rails.application.assets.find_asset(relative_pathname)
      ::Rails.public_path.join('assets', asset.digest_path) if asset
    end

    def relative_pathname
      pathname.relative_path_from(self.class.root)
    end
  end
end
