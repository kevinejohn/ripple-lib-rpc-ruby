module Ripple
  class Client
    module AccountInfo
      def balance
        response = connection.post do |req|
          req.url '/'
          req.headers['Content-Type'] = 'application/json'
          req.body = "{ \"method\" : \"account_info\", \"params\" : [ { \"account\" : \"#{client_account}\"} ] }"
        end
        return response.body.result.account_data.Balance.to_i
      end
    end
  end
end
