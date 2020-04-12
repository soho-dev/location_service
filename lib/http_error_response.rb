require "rack/utils"

class HttpErrorResponse < StandardError
  class << self
    def inherited(subclass)
      subclass.status_symbol = self.status_symbol
    end

    def status_symbol=(symbol)
      @symbol = symbol
    end

    def status_symbol
      @symbol || :internal_server_error
    end
  end

  def status_symbol
    self.class.status_symbol
  end

  def response_code
    Rack::Utils::SYMBOL_TO_STATUS_CODE[status_symbol]
  end

  class BadRequest < HttpErrorResponse
    self.status_symbol = :bad_request
  end

  class NotFound < HttpErrorResponse
    self.status_symbol = :not_found
  end
end
