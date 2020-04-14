# This file is used to toggle between which versioned API controllers to call.
# This pattern is derived from:
# http://railscasts.com/episodes/350-rest-api-versioning?view=asciicast

class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  # This strategy looks for the first number in the version string.
  # Meaning, if '2.0.0' is passed in, then routes for version '2' will match.
  def matches?(request)
    return true if @default
    requested_version = version_from_request(request)
    !!requested_version && requested_version.major == @version.to_i
  end

  def version_from_request(request)
    header = api_version_header_from_request(request)
    header && RequestedVersion.new(header)
  end

  # TODO: choose one and deprecate the others; see also Api::BaseController
  def api_version_header_from_request(request)
    request.headers["Api-Version"] ||
      request.headers["HTTP_X_API_VERSION"] ||
      request.headers["HTTP_API_VERSION"]
  end
end
