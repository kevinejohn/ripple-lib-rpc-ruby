module Ripple
  class Client < API
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

    # Parameters for opts
    # :tx_blob           // Optional. Replaces all other parameters. Raw transaction
    # :transaction_type  // Optional. Default: 'Payment'
    # :destination       // Destination account
    # :amount            // Ammount to send
    # :SendMax           // Optional. Complex IOU send
    # :Paths             // Optional. Complex IOU send
    def submit(opts = {})
      params = {
        secret: client_secret,
      }
      if opts.key?(:tx_blob)
        params.merge!(opts)
      else
        if opts.key?(:SendMax) and opts.key?(:Paths)
          # Complex IOU send
          params.merge!({tx_json: {
            'TransactionType' => opts[:transaction_type] || 'Payment',
            'Account' => client_account,
            'Destination' => opts[:destination],
            'Amount' => opts[:amount],
            'SendMax' => opts[:SendMax],
            'Paths' => opts[:Paths]
          }})
        else
          # Easy IOU Send
          params.merge!({tx_json: {
            'TransactionType' => opts[:transaction_type] || 'Payment',
            'Account' => client_account,
            'Destination' => opts[:destination],
            'Amount' => opts[:amount]
          }})
        end
      end
      # puts "Submit: " + params.inspect
      post(:submit, params)
    end

    def transaction_entry(opts={})
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
