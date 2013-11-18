require 'ripple'

ripple = Ripple.client({
  endpoint: "http://s1.ripple.com:51234/",
  client_account: "r4LADqzmqQUMhgSyBLTtPMG4pAzrMDx7Yj",
  client_secret: "ssm5HPoeEZYJWvkJvQW9ro6e6hW9m"
})

begin
    success = true
    begin
        puts "Sending transaction"
        tx_hash = ripple.send_currency("rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc", "USD", "0.0001")
    rescue Ripple::SubmitFailed
        # Handle failed submit
        puts "Transaction failed"
    rescue Ripple::ServerUnavailable
        puts "Server Unavailable"
        success = false
    end
end while success == false
# Verify transaction
begin
    puts "Checking transaction status"
end while not ripple.transaction_suceeded?(tx_hash)
puts "Transaction complete"
