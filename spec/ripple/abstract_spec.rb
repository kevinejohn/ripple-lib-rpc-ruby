require File.expand_path('../../spec_helper', __FILE__)
require 'json'
require 'digest/md5'
require 'pry-nav'

describe Ripple::Abstract do
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
        abstract.send(command)
      else
        abstract.send(command, params)
      end
    end
  end

  let(:abstract){ Ripple::Abstract.new }

  # High level methods
  context '#submit_transaction' do
    it 'should be successful sending XRP' do
      success = false
      begin
        params = {
          destination: "rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc",
          currency: 'XRP',
          amount: '1'
        }
        abstract.send_basic_transaction(params)
        success = true
      rescue Ripple::ServerUnavailable
      end while not success
    end

    it 'should be successful sending USD' do
      success = false
      begin
        params = {
          destination: "rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc",
          currency: 'USD',
          amount: '0.00001'
        }
        abstract.send_basic_transaction(params)
        success = true
      rescue Ripple::ServerUnavailable
      end while not success
    end


    it 'should return first path' do
      path = abstract.new_path(
        source_currency: 'USD',
        destination_account: "rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc",
        destination_amount: abstract.new_amount(
            value: '1',
            currency: 'XRP'
          )
        )

      success = false
      begin
        transaction = abstract.find_transaction_path(path)
        success = true
      rescue Ripple::ServerUnavailable
      end while not success
    end


    it 'should throw NoPathAvailable' do
      path = abstract.new_path(
        source_currency: 'USD',
        destination_account: "r4LADqzmqQUMhgSyBLTtPMG4pAzrMDx7Yj",
        destination_amount: abstract.new_amount(
            value: '1',
            currency: 'EUR',
            issuer: 'r4LADqzmqQUMhgSyBLTtPMG4pAzrMDx7Yj'
          )
        )
      success = false
      begin
        expect { transaction = abstract.find_transaction_path(path) }.to raise_error(Ripple::NoPathAvailable)
        success = true
      rescue Ripple::ServerUnavailable
      end while not success
    end


    it 'should be successful sending XRP from USD' do
      path = abstract.new_path(
        source_currency: 'USD',
        destination_account: "rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc",
        destination_amount: abstract.new_amount(
            value: '1',
            currency: 'XRP'
          )
        )

      success = false
      begin
        transaction = abstract.find_transaction_path(path)
        tx_hash = abstract.submit_transaction(transaction)
        puts tx_hash
        success = true
      rescue Ripple::ServerUnavailable
      end while not success
    end

  end

  context '#transaction_suceeded' do
    it 'should be successful' do
      success = false
      begin
        resp = abstract.transaction_suceeded?("84062717735DD0E6255F3A64750F543020D7DA05AA344012EFF1FEFB8213F735")
        resp.should be_true
        success = true
      rescue Ripple::ServerUnavailable
      end while not success
    end

    it 'should fail from invalid tx_tash' do
      success = false
      expect {
        begin
           abstract.transaction_suceeded?("94062717735DD0E6255F3A64750F543020D7DA05AA344012EFF1FEFB8213F735")
          success = true
        rescue Ripple::ServerUnavailable
        end while not success
      }.to raise_error(Ripple::InvalidTxHash)
    end
  end


  context '#xrp_balance' do
    it 'should be successful' do
      success = false
      begin
        puts abstract.xrp_balance
        success = true
      rescue Ripple::ServerUnavailable
      end while not success
    end
  end

  context '#iou_lines' do
    it 'should be successful' do
      success = false
      begin
        abstract.iou_lines
        success = true
      rescue Ripple::ServerUnavailable
      end while not success
    end
  end
end
