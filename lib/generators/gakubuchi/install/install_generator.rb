module Gakubuchi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer_file
        copy_file 'gakubuchi.rb', 'config/initializers/gakubuchi.rb'
      end
    end
  end
end
