require "gakubuchi/configuration"
require "gakubuchi/fileutils"

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
        ::Gakubuchi::FileUtils.copy_p(src, dest)

        unless leave_digest_named_templates?
          ::Gakubuchi::FileUtils.remove([src, *::Dir.glob("#{src}.gz")])
        end
      end
    end

    def leave_digest_named_templates?
      !!::Gakubuchi.configuration.leave_digest_named_templates
    end
  end
end
