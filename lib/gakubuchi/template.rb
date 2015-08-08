module Gakubuchi
  class Template
    extend ::Forwardable

    attr_reader :pathname
    def_delegators :@pathname, :hash

    %w(== === eql?).each do |method_name|
      define_method(method_name) do |other|
        self.class == other.class &&
        @pathname.__send__(method_name, other.pathname)
      end
    end

    def self.all
      Dir.glob(root.join('**/*.html*')).map { |path| new(path) }
    end

    def self.root
      Rails.root.join(Gakubuchi.configuration.template_root)
    end

    def initialize(path)
      @pathname = Pathname.new(path)
    end

    def basename
      pathname.basename.to_s
    end

    def destination_pathname
      dirname = relative_pathname.dirname
      Rails.public_path.join(dirname, "#{relative_pathname.basename(extname)}.html")
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

    def precompiled_pathnames
      dirname = relative_pathname.dirname
      pattern = "#{relative_pathname.basename(extname)}-*.{html,html.gz}"

      Pathname.glob(Rails.public_path.join('assets', dirname, pattern))
    end

    def relative_pathname
      pathname.relative_path_from(self.class.root)
    end
  end
end
