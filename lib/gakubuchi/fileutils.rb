# frozen_string_literal: true
require "fileutils"
require "logger"

module Gakubuchi
  module FileUtils
    extend ::FileUtils

    class << self
      def copy_p(src, dest, options = {})
        mkdir_p(::File.dirname(dest))
        copy(src, dest, options)
        logging("Copied #{src} to #{dest}")
      end

      def remove(list, options = {})
        super(list, options)
        logging("Removed #{Array(list).join(' ')}")
      end

      def rm_rf(list, options = {})
        super(list, options)
        logging("Removed #{Array(list).join(' ')}")
      end

      private

      def logging(message)
        ::Logger.new(::STDOUT).info(message)
      end
    end
  end
end
