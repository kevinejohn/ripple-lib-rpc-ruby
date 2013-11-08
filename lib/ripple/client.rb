require 'ripple/client/account_info'
require 'ripple/client/account_lines'
require 'ripple/client/account_tx'

module Ripple
  class Client < API
    include Client::AccountInfo
    include Client::AccountLines
    include Client::AccountTx

    Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}
  end
end