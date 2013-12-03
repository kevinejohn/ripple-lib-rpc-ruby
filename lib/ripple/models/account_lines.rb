module Ripple
  module Model
    class AccountLines
      attr_accessor :response
      def lines
        self.response.lines
      end
    end
  end
end
