module Ripple
  class Client
    module AccountInfo
      def balance
        params = { "account" => client_account }
        response = post("account_info", params )
        return response.result.account_data.Balance.to_i
      end
    end
  end
end
