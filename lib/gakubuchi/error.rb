module Gakubuchi
  class Error < StandardError
    InvalidTemplate = Class.new(self)
    InvalidMimeType = Class.new(self)
  end
end
