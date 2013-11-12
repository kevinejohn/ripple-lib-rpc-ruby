module Ripple
  class Client < API
    ######################
    # High level methods
    ######################
    def send_xrp(destination, amount)
      params = {
        destination: destination,
        amount: amount
      }
      submit(params)
    end

    def send_iou(destination, currency, amount)
      params = {
        destination: destination,
        amount: {
           currency: currency,
           value: amount,
           issuer: destination
        }
      }
      submit(params)
    end

    # def send_other_currency(destination, source_currency, destination_currency, destination_amount)
    #   # Find paths

    #   # Submit path
    #   params = {
    #     destination: destination,
    #     amount: {
    #        currency: currency,
    #        value: amount,
    #        issuer: destination
    #     }
    #   }
    #   submit(params)
    # end

    ####################
    # Low level methods
    ####################
    def account_info
      post(:account_info, {account: client_account})
    end

    def account_lines
      params = {
        account: client_account,
        ledger: :current
      }
      post(:account_lines, params)
    end

    def account_offers
      params = {
        account: client_account,
        ledger: :current
      }
      post(:account_offers, params)
    end

    def account_tx(opts = {})
      params = {
        account: client_account,
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

    def path_find

    end

    def ping
      post(:ping)
    end

    def ripple_path_find

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
