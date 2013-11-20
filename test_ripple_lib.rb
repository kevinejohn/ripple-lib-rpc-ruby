#require 'ripple'
require './lib/ripple'


ripple = Ripple.client({
  endpoint: "http://s1.ripple.com:51234/",
  client_account: "r4LADqzmqQUMhgSyBLTtPMG4pAzrMDx7Yj",
  client_secret: "ssm5HPoeEZYJWvkJvQW9ro6e6hW9m"
})

# Send and verify with error checking
success = false
begin
    failed = false
    begin
        puts "Sending transaction"
        tx_hash = ripple.send_currency("rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc", "USD", "0.0001")
        success = true
    rescue Ripple::SubmitFailed
        # Handle failed submit
        puts "Transaction failed"
        failed = true
    rescue Ripple::ServerUnavailable
        puts "Server Unavailable"
    end
end while not success and not failed
if success
    # Verify transaction
    complete = false
    begin
      begin
        puts "Checking transaction status"
        complete = ripple.transaction_suceeded?(tx_hash)
      rescue Ripple::InvalidTxHash
        puts "Invalid Tx Hash"
      rescue Ripple::ServerUnavailable
        puts "Server Unavailable"
      end
      if not complete
        # Sleep for small amount of time before checking again
        sleep 0.5
      end
    end while not complete
    puts "Transaction complete"
end
