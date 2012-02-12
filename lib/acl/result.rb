module Acl
  class Result

    attr_reader :message

    def initialize(result, message = nil)
      @result = result
      @message = message
    end

    def error?
      return !@result
    end
  end
end
