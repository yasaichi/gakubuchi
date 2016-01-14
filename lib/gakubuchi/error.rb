module Gakubuchi
  class Error < StandardError
    InvalidTemplate = Class.new(self)
  end
end
