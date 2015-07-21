require 'gakubuchi/fileutils'

module Gakubuchi
  class Task
    attr_reader :templates

    def initialize(templates)
      @templates = Array(templates)
    end

    def execute!
      templates.each do |template|
        precompiled_pathnames = template.precompiled_pathnames

        src = precompiled_pathnames
          .select  { |pathname| pathname.extname == '.html' }
          .sort_by { |pathname| pathname.mtime }
          .last

        next if src.nil?
        dest = template.destination_pathname

        Gakubuchi::FileUtils.copy_p(src, dest)
        Gakubuchi::FileUtils.remove(precompiled_pathnames) if remove_precompiled_templates?
      end
    end

    def remove_precompiled_templates?
      !!Gakubuchi.configuration.remove_precompiled_templates
    end
  end
end
