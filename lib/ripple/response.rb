module Ripple
  class Response
    attr_accessor :result

    def initialize(response_hash)
      self.result = response_hash.result

      # Check for status
      if result.status == 'success'
        result
      else
        # Error
        # TODO: Make more specific
        raise StandardError
      end
    end
  end
end
