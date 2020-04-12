#require "lib/http_error_response"

class ApiTokenAuthentication
  class MissingToken < HttpErrorResponse
    self.status_symbol = :unauthorized

    def message
      "Must provide API token"
    end
  end
  class TokenMismatch < HttpErrorResponse
    self.status_symbol = :forbidden

    def message
      "Invalid API token"
    end
  end

  attr_reader :api_token

  def initialize(api_token: nil)
    raise MissingToken if api_token.nil?
    @api_token = api_token
  end

  def authenticate
    raise TokenMismatch unless
      self.class.valid_api_tokens.include?(api_token)
  end

  def self.valid_api_tokens
    @valid_api_tokens ||= self.config['tokens']
  end

  def self.config
    @config ||= YAML.load(ERB.new(File.read(File.join(Rails.root, 'config', 'api_token.yml'))).result)
  end

end
