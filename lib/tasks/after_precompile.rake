Rake::Task['assets:precompile'].enhance do
  task = Gakubuchi::Task.new(Gakubuchi::Template.all)
  task.execute!
end
