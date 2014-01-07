module Ripple
  module Model
    class Transaction
      attr_accessor :destination_account
      attr_accessor :destination_amount
      attr_accessor :destination_tag
      attr_accessor :invoice_id
      attr_accessor :source_account
      attr_accessor :source_currency
      attr_accessor :send_max
      attr_accessor :path
      attr_accessor :response

      def initialize(transaction_json={})
        self.destination_account = transaction_json[:destination_account]
        self.destination_amount = transaction_json[:destination_amount]
        self.destination_tag = transaction_json[:destination_tag]
        self.source_account = transaction_json[:source_account]
        self.source_currency = transaction_json[:source_currency]
        self.send_max = transaction_json[:send_max]
        self.path = transaction_json[:path]
        self.invoice_id = transaction_json[:invoice_id]
      end

      # Initialize a basic transaction
      # Parameters:
      #   destination
      #   currency
      #   amount
      def self.init_basic_transaction(params={})
        obj = Transaction.new
        obj.destination_account = params[:destination]
        obj.destination_amount = Ripple::Model::Amount.new(
          value: params[:amount],
          issuer: params[:destination],
          currency: params[:currency]
          )
        obj
      end

      def source_amount
        self.path.source_amount
      end

      def print_path_info
        if self.path
          puts "Sending #{self.destination_amount.value} #{self.destination_amount.currency} to #{self.destination_account} for #{self.source_amount.value} #{self.source_amount.currency}"
        else
          puts "Path not found"
        end
      end

      def valid?
        # TODO: validate transaction
        true
      end

      #
      def tx_hash
        if self.response.resp.engine_result != 'tesSUCCESS'
          # Failed
          # puts "Failed Transaction: " + response.resp.inspect
          raise SubmitFailed, response.resp.engine_result_message
        end
        # Return transaction hash
        self.response.resp.tx_json['hash']
      end

      def tx_blob
        if self.response and self.response.resp.status == 'success' and self.response.resp.tx_blob
          return self.response.resp.tx_blob
        end
        return nil
      end

      def to_hash(options={})
        hash = nil
        if not tx_blob.nil?
          hash = {
            tx_blob: tx_blob
          }
        else
          hash = {
            destination: self.destination_account,
            amount: self.destination_amount.to_hash
          }
          if self.invoice_id
            hash[:InvoiceID] = self.invoice_id
          end
          if self.destination_tag
            hash[:DestinationTag] = self.destination_tag
          end
          if self.path
            # Complex send
            hash[:SendMax] = self.path.source_amount.to_hash
            hash[:Paths] = self.path.paths_computed
          end
        end
        hash
      end

      def to_json(options={})
        to_hash(options).to_json
      end
    end
  end
end
