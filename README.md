ripple-lib-rpc-ruby
===================

Ripple Client Ruby Gem

## Installation

Add this line to your application's Gemfile:

    gem 'ripple_lib_rpc_ruby', :git => 'git@github.com:kevinejohn/ripple-lib-rpc-ruby.git'

And then execute:

    $ bundle

## Usage

    # WARNING!
    # The client does not do local signing of transactions at this point. You must use a trusted endpoint!
    # WARNING!

    require 'ripple'

    ripple = Ripple.client(
      endpoint: "http://s1.ripple.com:51234/",
      client_account: "r4LADqzmqQUMhgSyBLTtPMG4pAzrMDx7Yj",
      client_secret: "ssm5HPoeEZYJWvkJvQW9ro6e6hW9m"
      )

    # Send XRP
    tx_hash = ripple.send_basic_transaction({destination: "rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc",currency: "XRP",amount: "1"})

    # Send IOU
    tx_hash = ripple.send_basic_transaction({destination: "rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc",currency: "USD",amount: "0.00001"})

    # XRP Balance
    balance = ripple.xrp_balance

    # Verify tx_hash
    begin
      if ripple.transaction_suceeded?("84062717735DD0E6255F3A64750F543020D7DA05AA344012EFF1FEFB8213F735")
        puts "Transaction complete"
      else
        puts "Transaction Pending"
      end
    rescue Ripple::InvalidTxHash
      puts "Invalid transaction"
    end


    # Send and confirm with error checking
    success = false
    failed = false
    begin
      puts "Sending transaction"
      tx_hash = ripple.send_basic_transaction({destination: "rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc",currency: "USD",amount: "0.00001"})
      success = true
    rescue Ripple::SubmitFailed => e
      puts "Transaction failed: " + e.message
      failed = true
    rescue Ripple::ServerUnavailable
      puts "Server Unavailable"
    rescue Ripple::Timedout
      puts "Request timed out"
    end while not success and not failed
    if success
      # Verify transaction
      complete = false
      begin
        puts "Checking transaction status"
        complete = ripple.transaction_suceeded?(tx_hash)
        if not complete
          # Sleep for small amount of time before checking again
          sleep 1
        end
      rescue Ripple::InvalidTxHash
        puts "Invalid Tx Hash"
      rescue Ripple::ServerUnavailable
        puts "Server Unavailable"
      rescue Ripple::Timedout
        puts "Request timed out"
      end while not complete
      puts "Transaction complete"
    end



    # Send and confirm complex send with error checking
    # 1. Find path
    success = false
    begin
      puts "Finding Path"
      path = ripple.new_path(
        source_currency: 'USD',
        destination_account: "r44SfjdwtQMpzyAML3vJkssHBiQspdMBw9",
        destination_amount: ripple.new_amount(
          value: '1',
          currency: 'XRP',
          #issuer: 'r44SfjdwtQMpzyAML3vJkssHBiQspdMBw9'
          )
        )
      transaction = ripple.find_transaction_path(path)
      success = true
    rescue Ripple::ServerUnavailable
      puts "Server Unavailable"
    rescue Ripple::Timedout
      puts "Request timed out"
    end while not success
    # 2. Sign transaction
    success = false
    failed = false
    begin
      puts "Signing transaction"
      #transaction.print_path_info
      transaction = ripple.sign_transaction(transaction)
      success = true
    rescue Ripple::SubmitFailed => e
      puts "Signing failed: " + e.message
      failed = true
    rescue Ripple::ServerUnavailable
      puts "Server Unavailable"
    rescue Ripple::Timedout
      puts "Request timed out"
    end while not success and not failed
    # 3. Submit transaction
    if success
      success = false
      failed = false
      begin
        puts "Submitting transaction"
        transaction.print_path_info
        tx_hash = ripple.submit_transaction(transaction)
        success = true
      rescue Ripple::SubmitFailed => e
        puts "Transaction failed: " + e.message
        failed = true
      rescue Ripple::ServerUnavailable
        puts "Server Unavailable"
      rescue Ripple::Timedout
        puts "Request timed out"
      end while not success and not failed
    end
    # 4. Verify transaction
    if success
      complete = false
      begin
        puts "Checking transaction status"
        complete = ripple.transaction_suceeded?(tx_hash)
        if not complete
          # Sleep for small amount of time before checking again
          sleep 1
        end
      rescue Ripple::InvalidTxHash
        puts "Invalid Tx Hash"
      rescue Ripple::ServerUnavailable
        puts "Server Unavailable"
      rescue Ripple::Timedout
        puts "Request timed out"
      end while not complete
      puts "Transaction complete"
    end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
