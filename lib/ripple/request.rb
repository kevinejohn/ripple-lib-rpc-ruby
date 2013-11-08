module Ripple
  module Request
    def post(method, options = {})
      # RPC
      response = connection.post do |req|
        req.url '/'
        req.headers['Content-Type'] = 'application/json'
        req.body = { "method" => method, "params" => [options] }.to_json
      end
      return Response.create( response.body )
    end
  end
end
