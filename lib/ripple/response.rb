module Ripple
  class Response
    attr_accessor :resp

    def initialize(response_hash)
      self.resp = response_hash.result
      # Check for status
      if resp.status == 'success'
        resp.result
      elsif resp.status == 'error'
        # TODO: Is this the correct way?
        # puts response_hash.inspect
        raise MalformedTransaction "Malformed Transaction"
      else
        # Error
        # TODO: Make more specific
        raise StandardError
      end
    end

    def success?
      resp.status == 'success'
    end

    def method_missing(method_name, *args)
      if resp.respond_to?(method_name)
        resp.send(method_name)
      else
        super
      end
    end
  end
end
