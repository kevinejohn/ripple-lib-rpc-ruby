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

  class MalformedTransaction < StandardError; end

  class InvalidParameters < StandardError; end


  # Submit errors
  class SubmitFailed < StandardError; end

  # Happens when submitting transaction
  class ServerUnavailable < StandardError; end

  class Timedout < StandardError; end

  # ripple_find_path
  class NoPathAvailable < StandardError; end


  # transaction_suceeded? response on invalid transaction
  class InvalidTxHash < StandardError; end



  # Unknown error
  class UnknownError < StandardError; end
end
