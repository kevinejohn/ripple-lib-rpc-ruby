#require 'ripple'
require './lib/ripple'


ripple = Ripple.client(
  endpoint: "http://s1.ripple.com:51234/",
  client_account: "rPJ78bFzY54HNyuNvBs6Hch9Z3F2MvMjj6",
  client_secret: "secret"
)

# Send and verify with error checking
success = false
failed = false
begin
    puts "Sending transaction"

    transaction = Ripple::Model::Transaction.new(
      destination_account: 'r44SfjdwtQMpzyAML3vJkssHBiQspdMBw9',
      destination_amount: Ripple::Model::Amount.new(
        value: '1',
        currency: 'XRP',
        #issuer: 'r44SfjdwtQMpzyAML3vJkssHBiQspdMBw9'
        )
      )
    #puts transaction.to_json
    tx_hash = ripple.submit_transaction(transaction)
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

# Verify Transaction
begin
    if ripple.transaction_suceeded?("84062717735DD0E6255F3A64750F543020D7DA05AA344012EFF1FEFB8213F735")
        puts "Transaction complete"
    else
        puts "Transaction Pending"
    end
rescue Ripple::InvalidTxHash
    puts "Invalid transaction"
end


# Send complex IOU
# 1. Find path
success = false
begin
  puts "Finding Path"
  destination_amount = Ripple::Model::Amount.new(
    value: '0.00001',
    currency: 'EUR',
    issuer: 'r44SfjdwtQMpzyAML3vJkssHBiQspdMBw9'
    )
  path = Ripple::Model::Path.new(
    source_currency: 'USD',
    destination_account: "r44SfjdwtQMpzyAML3vJkssHBiQspdMBw9",
    destination_amount: destination_amount
    )
  transaction = ripple.find_transaction_path(path)
  success = true
rescue Ripple::ServerUnavailable
    puts "Server Unavailable"
end while not success
# 2. Submit transaction
success = false
failed = false
begin
  puts "Submitting transaction"
  tx_hash = ripple.submit_transaction(transaction)
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





