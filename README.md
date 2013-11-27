ripple-lib-rpc-ruby
===================

Ripple Client Ruby Gem

## Installation

Add this line to your application's Gemfile:

    gem 'ripple_lib_rpc_ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ripple_lib_rpc_ruby

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
    tx_hash = ripple.send_currency("rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc", "XRP" "1")

    # Send IOU
    tx_hash = ripple.send_currency("rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc", "USD", "0.0001")

    # Verify tx_hash
    if ripple.transaction_suceeded?(tx_hash)
        # Transaction complete
    else
        # Transaction Pending
    end


    # Send and verify with error checking
    success = false
    failed = false
    begin
        puts "Sending transaction"
        tx_hash = ripple.send_currency("r44SfjdwtQMpzyAML3vJkssHBiQspdMBw9", "USD", "0.00001")
        success = true
    rescue Ripple::SubmitFailed
        puts "Transaction failed"
        failed = true
    rescue Ripple::ServerUnavailable
        puts "Server Unavailable"
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
        end while not complete
        puts "Transaction complete"
    end



    # Send complex IOU
    # 1. Find path
    success = false
    begin
      puts "Finding Path"
      destination_amount = Ripple::Model::Amount.new(value: '0.00001', currency: 'EUR', issuer: 'r44SfjdwtQMpzyAML3vJkssHBiQspdMBw9')
      params = {
        destination_account: "r44SfjdwtQMpzyAML3vJkssHBiQspdMBw9",
        destination_amount: destination_amount.to_json,
        source_currency: 'USD'
      }
      path = ripple.find_first_available_path(params)
      success = true
    rescue Ripple::ServerUnavailable
        puts "Server Unavailable"
    end while not success
    # 2. Submit transaction
    success = false
    failed = false
    begin
      puts "Submitting transaction"
      params = {
        destination: "r44SfjdwtQMpzyAML3vJkssHBiQspdMBw9",
        destination_amount: destination_amount.to_json,
        path: path
      }
      tx_hash = ripple.send_other_currency(params)
      success = true
    rescue Ripple::SubmitFailed
      puts "Transaction Failed"
      failed = true
    rescue Ripple::ServerUnavailable
        puts "Server Unavailable"
    end while not success and not failed
    # 3. Verify transaction
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
      end while not complete
      puts "Transaction complete"
    end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
