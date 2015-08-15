Gakubuchi.configure do |config|
  # Set this configuration to true if you want to leave digest-named templates
  # in public/assets directory. By default, Gakubuchi removes them after making
  # the non-digest-named copies in public directory.
  # config.leave_digest_named_templates = false

  # Name of directory for templates ('<%= DEFAULT_DIRECTORY %>' by default).
  # Gakubuchi treats "app/assets/#{config.template_directory}" as root directory
  # for static pages you want to manage with Asset Pipeline.
  <%- if options.directory.blank? || options.directory == DEFAULT_DIRECTORY -%>
  # config.template_directory = '<%= DEFAULT_DIRECTORY %>'
  <%- else -%>
  config.template_directory = '<%= options.directory %>'
  <%- end -%>
end
