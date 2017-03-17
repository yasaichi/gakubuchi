# frozen_string_literal: true
require "gakubuchi/error"
require "set"

module Gakubuchi
  class MimeType
    CONTENT_TYPE_FORMAT = %r(\A[^/]+/[^/]+\z)

    attr_reader :content_type, :extensions

    def initialize(content_type, extensions: [])
      unless content_type =~ CONTENT_TYPE_FORMAT
        message = %(`#{content_type}' is invalid as Content-Type)
        raise ::Gakubuchi::Error::InvalidMimeType, message
      end

      @content_type = content_type
      @extensions = ::Set.new(extensions).map(&:to_s)
    end
  end
end
