# frozen_string_literal: true
require "fileutils"
require "gakubuchi/template"

Rake::Task["assets:clobber"].enhance do
  logger = Logger.new($stdout)
  destination_paths = Gakubuchi::Template.all.map(&:destination_path)

  # TODO: Extract the followings as an instance method
  destination_paths.group_by(&:dirname).each do |dirname, templates|
    files = dirname == Rails.public_path ? templates : dirname

    FileUtils.rm_rf(files, secure: true)
    logger.info("Removed #{files.join(' ')}")
  end
end
