module Gakubuchi
  class PublicExceptions < ::ActionDispatch::PublicExceptions
    def render_html(status)
      view_context = ::ActionView::Base.new
      digest_path = view_context.asset_digest_path("#{status}.#{I18n.locale}.html") ||
                    view_context.asset_digest_path("#{status}.html")
      if digest_path
        path = File.join(public_path, view_context.assets_prefix, digest_path)
        render_format(status, 'text/html', File.read(path))
      else
        super
      end
    end
  end
end
