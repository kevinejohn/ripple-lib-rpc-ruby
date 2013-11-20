module Ripple
  class Client < API
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

    # Returns first available path
    def find_first_available_path(opts = {})
      params = {
        source_account: opts[:source_account] || client_account,
        destination_account: opts[:destination_account],
        source_currencies: [
          currency: opts[:source_currency]
          ],
        destination_amount: {
           currency: opts[:destination_currency],
           value: opts[:destination_amount],
           issuer: opts[:destination_issuer]
        }
      }
      resp = ripple_path_find(params)
      if resp.resp.alternatives.count == 0
        raise NoPathAvailable
      else
        resp.resp.alternatives[0]
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



    ####################
    # Low level methods
    ####################
    def account_info(opts = {})
      params = {
        account: opts[:account] || client_account,
      }
      post(:account_info, params)
    end

    def account_lines(opts = {})
      params = {
        account: opts[:account] || client_account,
        ledger: :current
      }
      post(:account_lines, params)
    end

    def account_offers(opts = {})
      params = {
        account: opts[:account] || client_account,
        ledger: :current
      }
      post(:account_offers, params)
    end

    def account_tx(opts = {})
      params = {
        account: opts[:account] || client_account,
        ledger_index_min: -1,
        ledger_index_max: -1,
        binary: false,
        count: false,
        descending: false,
        offset: opts[:offset] || 0,
        limit: opts[:limit] || 10,
        forward: false
      }
      post(:account_tx, params)
    end

    def book_offers

    end

    def ledger(opts = {})
      params = {
        full: opts[:full] || false,
        expand: opts[:expand] || false,
        transactions: opts[:transactions] || true,
        accounts: opts[:accounts] || true
      }
      post(:ledger, params)
    end

    def ledger_closed
      post(:ledger_closed)
    end

    def ledger_current
      post(:ledger_current)
    end

    def ledger_entry
      params = {
        type: :account_root,
        account_root: client_account,
        ledger_hash: :validated
      }
      post(:ledger_entry, params)
    end

    # NOTE: path_find is not supported on RPC
    # def path_find
    #   params = {
    #     source_account: client_account,
    #     destination_account: opts[:destination],
    #     destination_amount: opts[:amount],
    #     source_currencies: [
    #        {
    #          currency: opts[:source_currency]
    #          #issuer: client_account     # optional
    #        }
    #     ]
    #     # ledger_hash: ledger         # optional
    #     # "ledger_index" : ledger_index   // optional, defaults 'current'
    #   }
    #   post(:path_find, params)
    # end

    def ping
      post(:ping)
    end

    def ripple_path_find(opts = {})
      params = {
        source_account: opts[:source_account] || client_account,
        destination_account: opts[:destination_account],
        destination_amount: opts[:destination_amount],
        source_currencies: opts[:source_currencies]
        # ledger_hash: ledger         # optional
        # "ledger_index" : ledger_index   // optional, defaults 'current'
      }
      # puts JSON(params)
      post(:ripple_path_find, params)
    end

    def server_info
      post(:server_info)
    end

    def server_state
      post(:server_state)
    end

    def sign(opts = {})
      params = {
        secret: client_secret,
        tx_json: {
          'TransactionType' => opts[:transaction_type] || 'Payment',
          'Account' => client_account,
          'Destination' => opts[:destination],
          'Amount' => opts[:amount]
        }
      }
      post(:sign, params)
    end

    def submit(opts = {})
      params = {
        secret: client_secret,
      }
      if opts.key?(:tx_blob)
        params.merge!(opts)
      else
        params.merge!({tx_json: {
          'TransactionType' => opts[:transaction_type] || 'Payment',
          'Account' => client_account,
          'Destination' => opts[:destination],
          'Amount' => opts[:amount]
        }})
      end
      post(:submit, params)
    end

    def transaction_entry(tx_hash, ledger_index)
      params = {
        tx_hash: tx_hash,
        ledger_index: ledger_index
      }
      post(:transaction_entry, params)
    end

    def tx(tx_hash)
      post(:tx, {transaction: tx_hash})
    end

    def tx_history(start = 0)
      post(:tx_history, {start: start})
    end
  end
end
