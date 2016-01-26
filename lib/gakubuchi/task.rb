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
        FileUtils.copy_p(src, dest)

        FileUtils.remove([src, *::Dir.glob("#{src}.gz")]) unless leave_digest_named_templates?
      end
    end

    def leave_digest_named_templates?
      !!::Gakubuchi.configuration.leave_digest_named_templates
    end
  end
end
