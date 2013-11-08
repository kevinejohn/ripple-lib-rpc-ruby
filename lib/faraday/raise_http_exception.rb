require 'faraday'

# @private
module FaradayMiddleware
  # @private
  class RaiseHttpException < Faraday::Middleware
    def initialize(app)
      super app
      @parser = nil
    end

    def call(env)
      @app.call(env).on_complete do |response|
        case response[:status].to_i
        when 400
          raise Ripple::BadRequest, error_message_400(response)
        when 404
          raise Ripple::NotFound, error_message_400(response)
        when 500
          raise Ripple::InternalServerError, error_message_500(response, "Something is technically wrong.")
        end
      end
    end

    private

    def error_message_400(response)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{response[:status]}#{error_body(response[:body])}"
    end

    def error_body(body)
      # body gets passed as a string, not sure if it is passed as something else from other spots?
      if !body.nil? && !body.empty? && body.is_a?(String)
        # removed multi_json thanks to wesnolte's commit
        body = ::JSON.parse(body)
      end

      if body.nil?
        nil
      elsif body['meta'] && body['meta']['error_message'] && !body['meta']['error_message'].empty?
        ": #{body['meta']['error_message']}"
      end
    end

    def error_message_500(response, body = nil)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{[response[:status].to_s + ':', body].compact.join(' ')}"
    end
  end
end
  