module Ripple
  module Response
    def self.create( response_hash )
      result = response_hash.result

      # Check for status
      if result.status == 'success'
        return result
      else
        # Error
        # TODO: Make more specific
        raise Exception
      end
    end
  end
end
