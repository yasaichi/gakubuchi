# frozen_string_literal: true
module Gakubuchi
  class Error < ::StandardError
    InvalidTemplate = ::Class.new(self)
    InvalidMimeType = ::Class.new(self)
  end
end
