require File.expand_path('../../../spec_helper', __FILE__)

describe Ripple::Client do
  context ".account_info" do
    it "should return the balance of an account" do
      Ripple.configure do |config|
        config.client_account = "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh"
      end
      balance = VCR.use_cassette('account_info') do
        Ripple.balance
      end
      puts balance
      balance.should be >= 0
    end

    # it "should fail to connect to the server" do
    #   Ripple.configure do |config|
    #     config.endpoint = "http://invalid-url-woeifwoiejf.com/"
    #     config.client_account = "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh"
    #   end

    #   balance = Ripple.balance
    #   puts balance
    #   balance.should be >= 0
    # end
  end
end
