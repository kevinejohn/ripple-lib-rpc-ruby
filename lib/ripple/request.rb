require 'json'

module Ripple
  module Request
    def post(method, options = {})
      # RPC
      response = connection.post do |req|
        req.url '/'
        req.body = {method: method, params: [options]}
      end
      Response.new(response.body)
    end
  end
end