# frozen_string_literal: true
require "gakubuchi/template"
require "gakubuchi/fileutils"

Rake::Task["assets:clobber"].enhance do
  destination_paths = Gakubuchi::Template.all.map(&:destination_path)

  # TODO: Extract the followings as an instance method
  destination_paths.group_by(&:dirname).each do |dirname, templates|
    if dirname == Rails.public_path
      Gakubuchi::FileUtils.remove(templates, force: true)
    else
      Gakubuchi::FileUtils.rm_rf(dirname, secure: true)
    end
  end
end
