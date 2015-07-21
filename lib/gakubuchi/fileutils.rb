require 'fileutils'

module Gakubuchi
  module FileUtils
    extend ::FileUtils

    class << self
      def copy_p(src, dest)
        mkdir_p(File.dirname(dest))
        copy(src, dest)
        logging("Copied #{src} to #{dest}")
      end

      def remove(list)
        super(list)
        logging("Removed #{list.join(' ')}")
      end

      private

      def logging(message)
        Logger.new(STDOUT).info(message)
      end
    end
  end
end
