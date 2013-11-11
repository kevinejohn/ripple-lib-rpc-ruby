require 'json'

module Ripple
  module Request
    def post(method, options = {})
      # RPC
      response = connection.post do |req|
        req.url '/'
        req.body = {method: method}
        unless options.empty? || options.nil?
          req.body.merge!(params: [options])
        end
      end
      Response.new(response.body)
    end
  end
end