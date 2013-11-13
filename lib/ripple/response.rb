module Ripple
  class Response
    attr_accessor :resp

    def initialize(response_hash)
      self.resp = response_hash.result
    end

    def success?
      resp.status == 'success'
    end

    def raise_errors
      if resp.status == 'error'
        # TODO: Is this the correct way?
        # puts response_hash.inspect

        if resp.error == 'invalidParams'
          raise InvalidParameters
        elsif resp.error = 'malformedTransaction'
          raise MalformedTransaction, resp.error_message
        else
          raise UnknownError
        end
      else
        # Error
        # TODO: Make more specific
        puts response_hash.inspect
        raise StandardError
      end
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
