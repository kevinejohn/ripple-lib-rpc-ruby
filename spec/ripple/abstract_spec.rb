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
      abstract.send_basic_transaction("rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc", "XRP", "1")
    end

    it 'should be successful sending USD' do
      abstract.send_basic_transaction("rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc", "USD", "0.00001")
    end


    it 'should return first path' do
      destination_amount = Ripple::Model::Amount.new(
        value: '1',
        currency: 'XRP'
        )
      path = Ripple::Model::Path.new(
        source_currency: 'USD',
        destination_account: "rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc",
        destination_amount: destination_amount
        )
      transaction = abstract.find_transaction_path(path)
    end


    it 'should throw NoPathAvailable' do
      destination_amount = Ripple::Model::Amount.new(
        value: '1',
        currency: 'EUR',
        issuer: 'r4LADqzmqQUMhgSyBLTtPMG4pAzrMDx7Yj'
        )
      path = Ripple::Model::Path.new(
        source_currency: 'USD',
        destination_account: "r4LADqzmqQUMhgSyBLTtPMG4pAzrMDx7Yj",
        destination_amount: destination_amount
        )
      expect { transaction = abstract.find_transaction_path(path) }.to raise_error(Ripple::NoPathAvailable)
    end


    it 'should be successful sending XRP from USD' do
      destination_amount = Ripple::Model::Amount.new(
        value: '1',
        currency: 'XRP'
        )
      path = Ripple::Model::Path.new(
        source_currency: 'USD',
        destination_account: "rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc",
        destination_amount: destination_amount
        )
      transaction = abstract.find_transaction_path(path)
      tx_hash = abstract.submit_transaction(transaction)
      puts tx_hash
    end

  end

  context '#transaction_suceeded' do
    it 'should be successful' do
      resp = abstract.transaction_suceeded?("84062717735DD0E6255F3A64750F543020D7DA05AA344012EFF1FEFB8213F735")
      resp.should be_true
    end

    it 'should fail from invalid tx_tash' do
      expect { abstract.transaction_suceeded?("94062717735DD0E6255F3A64750F543020D7DA05AA344012EFF1FEFB8213F735") }.to raise_error(Ripple::InvalidTxHash)
    end
  end
end
