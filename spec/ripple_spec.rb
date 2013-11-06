require 'ripple-lib-rpc-ruby'

describe RippleLibRpcRuby, "#balance" do
  it "returns balance of ripple account" do
    ripple = RippleLibRpcRuby.new({ account: "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh", server: "http://s1.ripple.com:51234" })

    #puts ripple.balance
    ripple.balance.should be >= 0
  end


  it "returns invalid server" do
    ripple = RippleLibRpcRuby.new({ account: "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh", server: "http://invalid-url.com:51234" })

    #puts ripple.balance
  end
end
