module Ripple
  class Client
    module AccountLines
      def account_lines
        params = {
          account: client_account,
          ledger: :current
        }
        response = post(:account_lines, params)
        return response.body
      end
    end
  end
end
