module Ripple
  class Federation
    def bridge(gateway)
      # Check 3 canonical locations
      url_one = "https://ripple.#{gateway}/ripple.txt"
      url_two = "https://www.#{gateway}/ripple.txt"
      url_three = "https://#{gateway}/ripple.txt"

      begin
        response = Faraday.get url_one
        puts response.inspect
      rescue Faraday::Error::ConnectionFailed
        raise ConnectionFailed
      rescue Faraday::Error::TimeoutError
        raise Timedout
      end
      response

      # conn = Faraday.new(:url => 'http://sushi.com') do |faraday|
      #   faraday.request  :url_encoded             # form-encode POST params
      #   faraday.response :logger                  # log requests to STDOUT
      #   faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      # end

      # ## GET ##

      # response = conn.get '/nigiri/sake.json'     # GET http://sushi.com/nigiri/sake.json
      # response.body




      # options = {
      #   #headers: {'Accept' => "application/json; charset=utf-8", 'User-Agent' => user_agent},
      #   url: url_three
      # }

      # connection = Faraday::Connection.new(options) do |connection|
      #   connection.use FaradayMiddleware::RaiseHttpException
      # end

      # begin
      #   response = connection.get do |req|
      #     # req.url url_three
      #     # req.body = options
      #     # puts JSON(req.body)
      #   end
      #   #response
      #   #puts response.inspect
      #   #Response.new(response.body)
      # rescue Faraday::Error::ConnectionFailed
      #   raise ConnectionFailed
      # rescue Faraday::Error::TimeoutError
      #   raise Timedout
      # end

      # response
    end

  end
end
