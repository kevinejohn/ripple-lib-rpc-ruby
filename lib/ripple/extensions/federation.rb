module Ripple
  class Federation
    def service_declaration(gateway)
      # Check 3 canonical locations
      urls = [
        "https://ripple.#{gateway}/ripple.txt",
        "https://www.#{gateway}/ripple.txt",
        "https://#{gateway}/ripple.txt"
      ]

      response = nil
      urls.each do |url|
        begin
          response = Faraday.get url
          break
        rescue Faraday::Error::ConnectionFailed
          # raise ConnectionFailed
        rescue Faraday::Error::TimeoutError
          # raise Timedout
        end
      end

      bridge = nil
      if response
        lines = response.body.to_s.split("\n")
        lines.each_with_index do |line, index|
          if line == '[federation_url]' and lines.count > (index + 1)
            bridge = lines[index+1]
            break
          end
        end
      end

      bridge
    end

    # Parameters:
    #    url
    #    domain
    #    destination
    #    user
    def service_request(params={})
      url = "#{params[:url]}?type=federation&domain=#{params[:domain]}&destination=#{params[:destination]}&user=#{params[:user]}"

      begin
        response = Faraday.get url

      rescue Faraday::Error::ConnectionFailed
        raise ConnectionFailed
      rescue Faraday::Error::TimeoutError
        raise Timedout
      end
    end
  end
end
