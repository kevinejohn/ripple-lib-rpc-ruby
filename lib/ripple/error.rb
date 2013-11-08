module Ripple
  # Raised when Ripple returns the HTTP status code 400
  class BadRequest < StandardError; end

  # Raised when Ripple returns the HTTP status code 404
  class NotFound < StandardError; end

  # Raised when Ripple returns the HTTP status code 500
  class InternalServerError < StandardError; end

  # Raised when Ripple returns the HTTP status code 503
  class ServiceUnavailable < StandardError; end

  # Raised when a subscription payload hash is invalid
  class InvalidSignature < StandardError; end
end