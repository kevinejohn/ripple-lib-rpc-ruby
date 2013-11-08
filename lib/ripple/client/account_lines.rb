module Ripple
  class Client < API
    module AccountLines
      def account_lines
        params = {
          account: client_account,
          ledger: :current
        }
        post(:account_lines, params).result
      end
    end
  end
end
