# frozen_string_literal: true
require "fileutils"
require "logger"
require "rails"

module Gakubuchi
  class Task
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def publish(templates)
      Array(templates).each do |template|
        src = template.digest_path
        next if src.nil?
        dest = template.destination_path

        copy_p(src, dest)
        logger.info("Copied #{src} to #{dest}")

        unless configuration.leave_digest_named_templates
          files = [src, *::Dir.glob("#{src}.gz")]

          ::FileUtils.remove(files)
          logger.info("Removed #{files.join(' ')}")
        end
      end
    end

    def remove(templates)
      Array(templates).each do |template|
        next unless template.destination_path.exist?

        template.destination_path.ascend do |path|
          break if path == ::Rails.public_path || path.directory? && path.entries.size != 2

          ::FileUtils.remove_entry_secure(path)
          logger.info("Removed #{path}")
        end
      end
    end

    private

    def copy_p(src, dest)
      ::FileUtils.mkdir_p(::File.dirname(dest))
      ::FileUtils.copy(src, dest)
    end

    def logger
      @logger ||= ::Logger.new($stdout)
    end
  end
end
