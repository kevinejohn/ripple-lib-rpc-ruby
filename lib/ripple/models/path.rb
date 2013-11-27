module Ripple
  module Model
    class Path
      # Response
      attr_accessor :source_amount
      attr_accessor :paths_computed
      attr_accessor :response

      attr_accessor :source_account
      attr_accessor :source_currency
      attr_accessor :destination_account
      attr_accessor :destination_amount

      def initialize(path_response)
        self.source_account = path_response[:source_account]
        self.source_currency = path_response[:source_currency]
        self.destination_account = path_response[:destination_account]
        self.destination_amount = path_response[:destination_amount]
      end

      def valid?
        # TODO: validate path
        true
      end

      def transaction
        if self.response.resp.alternatives.count == 0
          raise NoPathAvailable
        else
          # Create Path object
          path_response = self.response.resp.alternatives[0]
          self.source_amount = Ripple::Model::Amount.new(path_response.source_amount)
          self.paths_computed = path_response.paths_computed

          Ripple::Model::Transaction.new(
              destination_account: self.destination_account,
              destination_amount: self.destination_amount,
              path: self
              )
        end
      end

      def to_json(options = {})
        base_json = {
          destination_account: self.destination_account,
          source_currencies: [
            currency: self.source_currency
            ],
          destination_amount: self.destination_amount.to_json
        }
        if self.source_account
          base_json[:source_account] = self.source_account
        end
        base_json
      end
    end
  end
end
