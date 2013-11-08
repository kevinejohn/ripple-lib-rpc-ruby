require 'pry-nav'

module Ripple
  class Client < API
    module AccountInfo
      def balance
        params = {account: client_account}
        response = post(:account_info, params)
        response.result.account_data.Balance.to_i
      end
    end
  end
end