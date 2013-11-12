require File.expand_path('../../spec_helper', __FILE__)
require 'json'
require 'digest/md5'
require 'pry-nav'

describe Ripple::Client do
  before :all do
    Ripple.configure do |config|
      config.endpoint = 'http://s1.ripple.com:51234/'
      config.client_account = "r4LADqzmqQUMhgSyBLTtPMG4pAzrMDx7Yj"
      config.client_secret = "ssm5HPoeEZYJWvkJvQW9ro6e6hW9m"
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
    # it "should be successful" do
    #   params = {
    #     destination: 'rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc',
    #     amount: '0.0001',
    #     source_currency: 'USD'
    #   }
    #   resp = make_request(:submit, params)
    #   puts resp.body
    #   resp.should be_success
    # end
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

  context "#sign" do
    it "should be successful" do
      params = {
        destination: 'r3kmLJN5D28dHuH8vZNUZpMC43pEHpaocV',
        amount: '200000000'
      }
      resp = make_request(:sign, params)
      resp.should be_success
    end
  end

  context '#submit' do
    context 'basic' do
      it 'should be successful' do
        params = {
          destination: 'r3kmLJN5D28dHuH8vZNUZpMC43pEHpaocV',
          amount: '200000000'
        }
        resp = make_request(:submit, params)
        resp.should be_success
      end

      it 'can use a tx_blob' do
        params = {
          destination: 'r3kmLJN5D28dHuH8vZNUZpMC43pEHpaocV',
          amount: '200000000'
        }
        resp = make_request(:sign, params)
        blob = resp.tx_blob
        submit_resp = make_request(:submit, {tx_blob: blob})
        submit_resp.should be_success
      end
    end


    context 'live' do
      # it 'should be successful sending XRP' do
      #   params = {
      #     destination: 'rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc',
      #     amount: '1'
      #   }
      #   resp = client.send(:submit, params)
      #   resp.should be_success
      # end


      it 'should be successful sending XRP' do
        resp = client.send_xrp("rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc", "1")
        resp.should be_success
      end

      it 'should be successful sending USD' do
        resp = client.send_iou("rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc", "USD", "0.0001")
        resp.should be_success
      end

      # it 'should be successful sending USD' do
      #   params = {
      #     destination: 'rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc',
      #     amount: '1'
      #   }
      #   resp = client.send(:submit, params)
      #   resp.should be_success
      # end
    end

    context 'complex' do
    end
  end

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
