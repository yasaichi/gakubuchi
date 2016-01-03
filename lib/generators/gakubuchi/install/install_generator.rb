module Gakubuchi
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      DEFAULT_DIRECTORY = Gakubuchi::Configuration.new.template_directory.freeze

      desc 'Create a Gakubuchi initializer.'
      source_root ::File.expand_path('../templates', __FILE__)

      class_option :directory,
        type: :string,
        aliases: '-d',
        default: DEFAULT_DIRECTORY,
        desc: 'Name of directory for templates'

      def copy_initializer_file
        template 'gakubuchi.rb.erb', 'config/initializers/gakubuchi.rb'
      end

      def create_template_directory
        empty_directory Pathname.new('app/assets').join(options.directory)
      end
    end
  end
end
