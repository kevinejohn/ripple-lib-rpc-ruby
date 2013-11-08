class RippleLibRpcRuby
  def initialize(params)
    @conn = Faraday.new(url: "#{params[:server]}") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      #faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    @account = params[:account]
  end

  def balance
    ## POST ##

    # post payload as JSON instead of "www-form-urlencoded" encoding:
    resp = @conn.post do |req|
      req.url '/'
      req.headers['Content-Type'] = 'application/json'
      req.body = {method: "account_info", params: [{account: @account}]}

      #req.options.timeout = 5           # open/read timeout in seconds
      #req.options.open_timeout = 2      # connection open timeout in seconds
    end

    json_response = JSON.parse(resp.body)

    ap json_response

    json_response['result']['account_data']['Balance'].to_i

    # Check for success
    # if jsonResponse['result']['status'] == "success"
    #   jsonResponse['result']['account_data']['Balance']
    # else
    #   "Could not connect to server"
    # end
  end
end
