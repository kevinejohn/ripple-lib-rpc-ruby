require File.expand_path('../../spec_helper', __FILE__)

describe Ripple::Client do
  before :all do
    Ripple.configure do |config|
      config.client_account = "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh"
    end
  end

  let(:client){ Ripple::Client.new }

  it "should connect using the endpoint configuration" do
    endpoint = URI.parse(client.endpoint)
    connection = client.send(:connection).build_url(nil).to_s
    connection.should == endpoint.to_s
  end

  context '#account_info' do
    it "should be successful" do
      resp = VCR.use_cassette('account_info') do
        client.account_info
      end
      resp.should be_success
    end
  end

  context '#account_lines' do
    it "should be successful" do
      resp = VCR.use_cassette('account_lines') do
        client.account_lines
      end
      resp.should be_success
    end
  end

  context '#account_offers' do
    it "should be successful" do
      resp = VCR.use_cassette('account_lines') do
        client.account_offers
      end
      resp.should be_success
    end
  end

  context '#account_tx' do
    it "should be successful" do
      resp = VCR.use_cassette('account_tx') do
        client.account_tx
      end
      resp.should be_success
    end
  end

  context '#book_offers' do
  end

  context '#ledger' do
    it "should be successful" do
      resp = VCR.use_cassette('ledger') do
        client.ledger
      end
      resp.should be_success
    end
  end

  context '#ledger_closed' do
    it "should be successful" do
      resp = VCR.use_cassette('ledger_closed') do
        client.ledger_closed
      end
      resp.should be_success
    end
  end

  context '#ledger_current' do
    it "should be successful" do
      resp = VCR.use_cassette('ledger_closed') do
        client.ledger_current
      end
      resp.should be_success
    end
  end

  context '#ledger_entry' do
  end

  context '#path_find' do
  end

  context '#ping' do
    it "should be successful" do
      resp = VCR.use_cassette('ping') do
        client.ping
      end
      resp.should be_success
    end
  end

  context '#ripple_path_find' do
  end

  context '#server_info' do
    it "should be successful" do
      resp = VCR.use_cassette('server_info') do
        client.server_info
      end
      resp.should be_success
    end
  end

  context '#server_state' do
    it "should be successful" do
      resp = VCR.use_cassette('server_state') do
        client.server_state
      end
      resp.should be_success
    end
  end

  context '#submit' do
  end

  context '#transaction_entry' do
  end

  context '#tx' do
  end

  context '#tx_history' do
    it "should be successful" do
      resp = VCR.use_cassette('tx_history') do
        client.tx_history
      end
      resp.should be_success
    end
  end
end
