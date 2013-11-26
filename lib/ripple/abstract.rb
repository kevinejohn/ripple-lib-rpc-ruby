module Ripple
  class Abstract < Client
    ######################
    # High level methods
    ######################
    def send_currency(destination, currency, amount)
      if currency == 'XRP'
        params = {
          destination: destination,
          amount: amount
        }
      else
        # IOU
        params = {
          destination: destination,
          amount: {
             currency: currency,
             value: amount,
             issuer: destination
          }
        }
      end

      response = submit(params)

      if response.resp.engine_result != 'tesSUCCESS'
        # Failed
        puts response.resp.inspect
        raise SubmitFailed
      end
      # Return transaction hash
      response.resp.tx_json['hash']
    end

    # Complex IOU send
    def send_other_currency(opts = {})
      path = opts[:path]
      params = {
        destination: opts[:destination],
        amount: opts[:destination_amount],
        SendMax: path.source_amount.to_json,
        Paths: path.paths_computed
      }

      # puts "Sending other currency " + params.inspect
      response = submit(params)

      if response.resp.engine_result != 'tesSUCCESS'
        # Failed
        puts response.resp.inspect
        raise SubmitFailed
      end
      # Return transaction hash
      response.resp.tx_json['hash']
    end

    # Returns first available path
    def find_first_available_path(opts = {})
      params = {
        source_account: opts[:source_account] || client_account,
        destination_account: opts[:destination_account],
        source_currencies: [
          currency: opts[:source_currency]
          ],
        destination_amount: opts[:destination_amount]
      }
      #puts params.inspect
      resp = ripple_path_find(params)
      #puts resp.resp.inspect
      if resp.resp.alternatives.count == 0
        raise NoPathAvailable
      else
        # Create Path object
        Ripple::Model::Path.new(resp.resp.alternatives[0])
        #resp.resp.alternatives[0]
      end
    end

    # Returns true if tx_hash is completed.
    # Returns false if tx_hash is submitted but not complete
    # Raises Ripple::InvalidTxHash if tx_hash isnt found
    def transaction_suceeded?(tx_hash)
      response = tx(tx_hash)
      if response.success? and response.resp.validated == true and response.resp.meta.TransactionResult == 'tesSUCCESS'
        true
      elsif response.success? and response.resp['hash'] == tx_hash
        false
      else
        raise InvalidTxHash
      end
    end
  end
end
