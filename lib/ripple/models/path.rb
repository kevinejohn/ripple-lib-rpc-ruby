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

      # Pass throughs for transaction
      attr_accessor :destination_tag
      attr_accessor :invoice_id

      def initialize(path_response)
        self.source_account = path_response[:source_account]
        self.source_currency = path_response[:source_currency]
        self.destination_account = path_response[:destination_account]
        self.destination_amount = path_response[:destination_amount]

        self.destination_tag = path_response[:destination_tag]
        self.invoice_id = path_response[:invoice_id]
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
          #puts "Path response: " + path_response.to_json
          self.source_amount = Ripple::Model::Amount.new(path_response.source_amount)
          self.paths_computed = path_response.paths_computed

          transaction = Ripple::Model::Transaction.new(
              destination_account: self.destination_account,
              destination_amount: self.destination_amount,
              path: self
              )

          if self.destination_tag
            transaction.destination_tag = self.destination_tag
          end
          if self.invoice_id
            transaction.invoice_id = self.invoice_id
          end
          transaction
        end
      end

      def to_hash(options = {})
        base_json = {
          destination_account: self.destination_account,
          source_currencies: [
            currency: self.source_currency
            ],
          destination_amount: self.destination_amount.to_hash
        }
        if self.source_account
          base_json[:source_account] = self.source_account
        end
        base_json
      end

      def to_json(options={})
        to_hash(options).to_json
      end
    end
  end
end
