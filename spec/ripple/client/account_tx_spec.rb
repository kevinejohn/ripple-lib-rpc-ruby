require File.expand_path('../../../spec_helper', __FILE__)

describe Ripple::Client do
  describe ".account_tx" do
    it "should return the account tx" do
      Ripple.configure do |config|
        config.client_account = "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh"
      end

      Ripple.account_tx
    end
  end
end
