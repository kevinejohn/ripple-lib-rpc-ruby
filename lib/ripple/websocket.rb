require 'faye/websocket'
require 'eventmachine'
require 'singleton'

module Ripple
  module Connection
    class WebSocket
      include Singleton

      EM.run {
        ws = Faye::WebSocket::Client.new(endpoint)

        ws.on :open do |event|
          p [:open]
          #ws.send('Hello, world!')
        end

        ws.on :message do |event|
          p [:message, event.data]
        end

        ws.on :close do |event|
          p [:close, event.code, event.reason]
          ws = nil
        end
      }

      def post(command)
        ws.send(command)
      end
    end
  end
end
