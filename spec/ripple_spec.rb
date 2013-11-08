require File.expand_path('../spec_helper', __FILE__)

describe Ripple do
  after do
    Ripple.reset
  end

  describe ".client" do
    it "should be a Ripple::Client" do
      Ripple.client.should be_a Ripple::Client
    end
  end

  describe ".adapter" do
    it "should return the default adapter" do
      Ripple.adapter.should == Ripple::Configuration::DEFAULT_ADAPTER
    end
  end

  describe ".adapter=" do
    it "should set the adapter" do
      Ripple.adapter = :typhoeus
      Ripple.adapter.should == :typhoeus
    end
  end

  describe ".client_account" do
    it "should return the default client_account" do
      Ripple.client_account.should == Ripple::Configuration::DEFAULT_CLIENT_ACCOUNT
    end
  end

  describe ".client_account=" do
    it "should set the client_account" do
      Ripple.client_account = "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh"
      Ripple.client_account.should == "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh"
    end
  end

  describe ".client_secret" do
    it "should return the default client_secret" do
      Ripple.client_secret.should == Ripple::Configuration::DEFAULT_CLIENT_SECRET
    end
  end

  describe ".client_secret=" do
    it "should set the client_secret" do
      Ripple.client_secret = "spz7x7vjAgU1JuBcgabx8MmgNzLg7"
      Ripple.client_secret.should == "spz7x7vjAgU1JuBcgabx8MmgNzLg7"
    end
  end

  describe ".endpoint" do
    it "should return the default endpoint" do
      Ripple.endpoint.should == Ripple::Configuration::DEFAULT_ENDPOINT
    end
  end

  describe ".endpoint=" do
    it "should set the endpoint" do
      Ripple.endpoint = 'http://tumblr.com'
      Ripple.endpoint.should == 'http://tumblr.com'
    end
  end

  describe ".user_agent" do
    it "should return the default user agent" do
      Ripple.user_agent.should == Ripple::Configuration::DEFAULT_USER_AGENT
    end
  end

  describe ".user_agent=" do
    it "should set the user_agent" do
      Ripple.user_agent = 'Custom User Agent'
      Ripple.user_agent.should == 'Custom User Agent'
    end
  end

  describe ".configure" do

    Ripple::Configuration::VALID_OPTIONS_KEYS.each do |key|

      it "should set the #{key}" do
        Ripple.configure do |config|
          config.send("#{key}=", key)
          Ripple.send(key).should == key
        end
      end
    end
  end
end




# require 'ripple-lib-rpc-ruby'

# describe RippleLibRpcRuby, "#balance" do
#   it "returns balance of ripple account" do
#     ripple = RippleLibRpcRuby.new({ account: "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh", server: "http://s1.ripple.com:51234" })

#     #puts ripple.balance
#     ripple.balance.should be >= 0
#   end


#   it "returns invalid server" do
#     ripple = RippleLibRpcRuby.new({ account: "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh", server: "http://invalid-url.com:51234" })

#     #puts ripple.balance
#   end
# end
