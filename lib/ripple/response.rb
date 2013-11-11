require 'pry-nav'

module Ripple
  class Response
    attr_accessor :resp

    def initialize(response_hash)
      self.resp = response_hash.result

      # Check for status
      if resp.status == 'success'
        resp.result
      else
        # Error
        # TODO: Make more specific
        raise StandardError
      end
    end

    def success?
      resp.status == 'success'
    end
  end
end
