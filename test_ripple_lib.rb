#require 'ripple'
require './lib/ripple'


ripple = Ripple.client(
  endpoint: "http://s1.ripple.com:51234/",
  client_account: "r4LADqzmqQUMhgSyBLTtPMG4pAzrMDx7Yj",
  client_secret: "ssm5HPoeEZYJWvkJvQW9ro6e6hW9m"
  )

# Send XRP
tx_hash = ripple.send_basic_transaction("rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc", "XRP", "1")

# Send IOU
tx_hash = ripple.send_basic_transaction("rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc", "USD", "1")

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
  tx_hash = ripple.send_basic_transaction("rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc", "USD", "0.00001")
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
# 2. Submit transaction
success = false
failed = false
begin
  puts "Submitting transaction"
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
  rescue Ripple::Timedout
    puts "Request timed out"
  end while not complete
  puts "Transaction complete"
end





