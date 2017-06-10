# frozen_string_literal: true
require "fileutils"
require "gakubuchi/configuration"
require "gakubuchi/fileutils"
require "logger"

module Gakubuchi
  class Task
    attr_reader :templates

    def initialize(templates)
      @templates = Array(templates)
    end

    def execute!
      templates.each do |template|
        src = template.digest_path
        next if src.nil?
        dest = template.destination_path

        copy_p(src, dest)
        logger.info("Copied #{src} to #{dest}")

        unless leave_digest_named_templates?
          files = [src, *::Dir.glob("#{src}.gz")]

          ::FileUtils.remove(files)
          logger.info("Removed #{files.join(' ')}")
        end
      end
    end

    def leave_digest_named_templates?
      !!::Gakubuchi.configuration.leave_digest_named_templates
    end

    private

    def copy_p(src, dest)
      ::FileUtils.mkdir_p(::File.dirname(dest))
      ::FileUtils.copy(src, dest)
    end

    def logger
      @logger ||= ::Logger.new(::STDOUT)
    end
  end
end
