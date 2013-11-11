require File.expand_path('../../spec_helper', __FILE__)
require 'json'
require 'digest/md5'
require 'pry-nav'

describe Ripple::Client do
  before :all do
    Ripple.configure do |config|
      config.client_account = "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh"
    end
  end

  def make_request(command, params = {})
    params_digest = Digest::MD5.hexdigest(JSON.dump(params))
    VCR.use_cassette("#{command}-#{params_digest}") do
      if params.empty? || params.nil?
        client.send(command)
      else
        client.send(command, params)
      end
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
      resp = make_request(:account_info)
      resp.should be_success
    end
  end

  context '#account_lines' do
    it "should be successful" do
      resp = make_request(:account_lines)
      resp.should be_success
    end
  end

  context '#account_offers' do
    it "should be successful" do
      resp = make_request(:account_offers)
      resp.should be_success
    end
  end

  context '#account_tx' do
    it "should be successful" do
      resp = make_request(:account_tx)
      resp.should be_success
    end
  end

  context '#book_offers' do
  end

  context '#ledger' do
    it "should be successful" do
      resp = make_request(:ledger)
      resp.should be_success
    end
  end

  context '#ledger_closed' do
    it "should be successful" do
      resp = make_request(:ledger_closed)
      resp.should be_success
    end
  end

  context '#ledger_current' do
    it "should be successful" do
      resp = make_request(:ledger_current)
      resp.should be_success
    end
  end

  context '#ledger_entry' do
  end

  context '#path_find' do
  end

  context '#ping' do
    it "should be successful" do
      resp = make_request(:ping)
      resp.should be_success
    end
  end

  context '#ripple_path_find' do
  end

  context '#server_info' do
    it "should be successful" do
      resp = make_request(:server_info)
      resp.should be_success
    end
  end

  context '#server_state' do
    it "should be successful" do
      resp = make_request(:server_state)
      resp.should be_success
    end
  end

  # context "#sign" do
  #   it "should be successful" do
  #     resp = VCR.use_cassette('sign') do
  #       client.sign({
  #         secret: 'snoPBrXtMeMyMHUVTgbuqAfg1SUTb',
  #         transaction_type: 'Payment',
  #         destination: 'r3kmLJN5D28dHuH8vZNUZpMC43pEHpaocV',
  #         account: 'rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh',
  #         amount: '200000000'
  #       })
  #     end
  #     puts resp.inspect
  #     resp.should be_success
  #   end
  # end

  # context '#submit' do
  #   context 'basic' do
  #     it 'should be successful' do
  #       resp = VCR.use_cassette('basic_submit') do
  #         client.submit({
  #           secret: 'snoPBrXtMeMyMHUVTgbuqAfg1SUTb',
  #           transaction_type: 'Payment',
  #           destination: 'r3kmLJN5D28dHuH8vZNUZpMC43pEHpaocV',
  #           account: 'rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh',
  #           amount: '200000000'
  #         })
  #       end
  #       puts resp.inspect
  #       resp.should be_success
  #     end
  #   end

  #   context 'complex' do
  #   end
  # end

  context '#transaction_entry' do
  end

  context '#tx' do
  end

  context '#tx_history' do
    it "should be successful" do
      resp = make_request(:tx_history)
      resp.should be_success
    end
  end
end
