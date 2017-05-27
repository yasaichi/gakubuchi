# frozen_string_literal: true
require "gakubuchi/template"
require "gakubuchi/fileutils"

Rake::Task["assets:clobber"].enhance do
  destination_paths = Gakubuchi::Template.all.map(&:destination_path).select do |path|
    File.exist?(path)
  end
  Gakubuchi::FileUtils.remove(destination_paths)
end
