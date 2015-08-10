Gakubuchi.configure do |config|
  # Set this configuration to false if you want to leave precompiled templates
  # in public/assets. By default, Gakubuchi removes them after the precompile.
  # config.remove_precompiled_templates = true

  # Name of directory for templates ('<%= DEFAULT_DIRECTORY %>' by default).
  # Gakubuchi treats "app/assets/#{config.template_directory}" as root directory
  # for static pages you want to manage with Asset Pipeline.
  <%- if options.directory.blank? || options.directory == DEFAULT_DIRECTORY -%>
  # config.template_directory = '<%= DEFAULT_DIRECTORY %>'
  <%- else -%>
  config.template_directory = '<%= options.directory %>'
  <%- end -%>
end
