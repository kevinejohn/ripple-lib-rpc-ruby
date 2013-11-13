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

    ripple = Ripple.client({
      endpoint: "http://s1.ripple.com:51234/",
      client_account: "r4LADqzmqQUMhgSyBLTtPMG4pAzrMDx7Yj",
      client_secret: "ssm5HPoeEZYJWvkJvQW9ro6e6hW9m"
    })

    # Send XRP
    ripple.send_currency("rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc", "XRP" "1")

    # Send IOU
    ripple.send_currency("rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc", "USD", "0.0001")


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
