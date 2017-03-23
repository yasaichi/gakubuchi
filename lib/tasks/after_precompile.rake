# frozen_string_literal: true
require "gakubuchi/task"
require "gakubuchi/template"

Rake::Task["assets:precompile"].enhance do
  task = Gakubuchi::Task.new(Gakubuchi::Template.all)
  task.execute!
end
