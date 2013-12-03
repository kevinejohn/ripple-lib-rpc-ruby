module Ripple
  module Model
    class AccountInfo
      attr_accessor :response

      # def initialize(json)

      # end

      def balance
        self.response.account_data.Balance
      end
    end
  end
end
