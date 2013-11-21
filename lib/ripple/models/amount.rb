module Ripple
  module Model
    class Amount
      attr_accessor :currency
      attr_accessor :issuer
      attr_accessor :value

      def initialize(amount_json)
        if amount_json.key?('currency')
          # IOU
          self.currency = amount_json.currency
          self.issuer = amount_json.issuer
          self.value = amount_json.value
        else
          # XRP
          self.currency = 'XRP'
          self.issuer = ''
          self.value = amount_json
        end
      end

      def is_xrp?
        self.currency == 'XRP'
      end

      # def to_json
      #   if is_xrp?
      #     self.value
      #   else
      #     {currency: self.currency, issuer: self.issuer, value: self.value}
      #   end
      # end
    end
  end
end
