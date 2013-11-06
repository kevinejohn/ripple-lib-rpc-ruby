module Ripple
  class Client < API
    Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}

    include Ripple::Client::AccountInfo
  end
end
