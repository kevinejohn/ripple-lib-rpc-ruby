require 'json'

module Ripple
  module Request
    def post(method, options = {})
      if connection_type == 'RPC'
        # RPC
        begin
          response = connection.post do |req|
            req.url '/'
            req.body = {method: method}
            unless options.empty? || options.nil?
              req.body.merge!(params: [options])
            end
            # puts JSON(req.body)
          end
          # puts response.inspect
          Response.new(response.body)
        rescue Faraday::Error::ParsingError
          # Server unavailable
          raise ServerUnavailable
        rescue Faraday::Error::TimeoutError
          raise Timedout
        end
      else
        # Websocket
        # options[:command] = method
        # WebSocket.instance.post(options)
      end
    end
  end
end
