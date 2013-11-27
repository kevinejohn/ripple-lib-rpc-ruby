module Ripple
  class Abstract < Client
    ######################
    # High level methods
    ######################

    # Returns tx_hash if success
    def submit_transaction(transaction)
      transaction.valid?
      transaction.response = submit(transaction.to_json)
      transaction.response.raise_errors
      transaction.tx_hash
    end

    # Returns Transaction object if success
    def find_transaction_path(path)
      path.valid?
      path.response = ripple_path_find(path.to_json)
      #puts path.response.resp.inspect
      path.response.raise_errors
      path.transaction
    end

    def send_basic_transaction(destination, currency, amount)
      transaction = Ripple::Model::Transaction.init_basic_transaction(destination, currency, amount)
      submit_transaction(transaction)
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
