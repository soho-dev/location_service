module Api
  class BaseController < ActionController::Base

    def with_authorization(&block)
      catch_response_errors do
        api_token_authentication = ApiTokenAuthentication.new(api_token: api_token)
        api_token_authentication.authenticate
        block.call
      end
    end

    def api_token
      request.env["HTTP_API_TOKEN"] || params["HTTP_API_TOKEN"]
    end

    def catch_response_errors
      yield
    rescue HttpErrorResponse => e
      render json: {message: e.message}, status: 403
    end
  end
end
