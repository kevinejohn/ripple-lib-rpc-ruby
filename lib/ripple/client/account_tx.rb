module Ripple
  class Client
    module AccountTx
      def account_tx
        params = {
          account: client_account,
          ledger_index_min: -1,
          ledger_index_max: -1,
          binary: false,
          count: false,
          descending: false,
          offset: 0,
          limit: 10,
          forward: false
        }
        response = post(:account_tx, params)
        return response.body
      end
    end
  end
end
