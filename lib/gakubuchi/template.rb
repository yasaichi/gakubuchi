module Gakubuchi
  class Template
    attr_reader :pathname

    def self.all
      Dir.glob(root.join('**/*.html*')).map { |path| new(path) }
    end

    def self.root
      Rails.root.join(Gakubuchi::configuration.template_root)
    end

    def initialize(path)
      @pathname = Pathname.new(path)
    end

    def basename
      pathname.basename.to_s
    end

    def compiled_pathname
      dirname = relative_pathname.dirname
      pattern = "#{relative_pathname.basename(extname)}-*.{html,html.gz}"
      Rails.public_path.join('assets', dirname, pattern)
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

    def relative_pathname
      pathname.relative_path_from(self.class.root)
    end
  end
end
