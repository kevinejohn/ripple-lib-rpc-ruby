module Ripple
  module Model
    class Transaction
      attr_accessor :destination_account
      attr_accessor :destination_currency
      attr_accessor :destination_amount
      attr_accessor :source_account
      attr_accessor :source_currency
      attr_accessor :send_max
      attr_accessor :path
      attr_accessor :response

      def initialize(transaction_json={})
        self.destination_account = transaction_json[:destination_account]
        self.destination_currency = transaction_json[:destination_currency]
        self.destination_amount = transaction_json[:destination_amount]
        self.source_account = transaction_json[:source_account]
        self.source_currency = transaction_json[:source_currency]
        self.send_max = transaction_json[:send_max]
        self.path = transaction_json[:path]
      end

      # Initialize a basic transaction
      def self.init_basic_transaction(destination, currency, amount)
        obj = Transaction.new
        obj.destination_account = destination
        obj.destination_currency = currency
        obj.destination_amount = Ripple::Model::Amount.new(
          value: amount,
          issuer: destination,
          currency: currency
          )
        obj
      end

      def valid?
        # TODO: validate transaction
        true
      end

      def tx_hash
        if self.response.resp.engine_result != 'tesSUCCESS'
          # Failed
          # puts "Failed Transaction: " + response.resp.inspect
          raise SubmitFailed, response.resp.engine_result_message
        end
        # Return transaction hash
        self.response.resp.tx_json['hash']
      end

      def to_json(options = {})
        if self.path.nil?
          # Basic send
          {
            destination: self.destination_account,
            amount: self.destination_amount.to_json
          }
        else
          # Complex send
          {
            destination: self.destination_account,
            amount: self.destination_amount.to_json,
            SendMax: self.path.source_amount.to_json,
            Paths: self.path.paths_computed
          }
        end
      end
    end
  end
end
