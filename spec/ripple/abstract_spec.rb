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
  context '#send_currency' do
    it 'should be successful sending XRP' do
      begin
        resp = abstract.send_currency("rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc", "XRP", "1")
        abstract.transaction_suceeded?(resp)
      rescue Ripple::ServerUnavailable

      end
    end

    it 'should be successful sending USD' do
      begin
        resp = abstract.send_currency("rfGKu3tSxwMFZ5mQ6bUcxWrxahACxABqKc", "USD", "0.0001")
      rescue Ripple::ServerUnavailable

      end
    end


    it 'should return first path' do
      begin
        destination_amount = Ripple::Model::Amount.new(currency: 'EUR', value: '0.0001', issuer: 'rvYAfWj5gh67oV6fW32ZzP3Aw4Eubs59B')
        params = {
          destination_account: "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
          destination_amount: destination_amount.to_json,
          source_account: "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
          source_currency: 'USD'
        }
        path = abstract.find_first_available_path(params)
      end
    end


    it 'should throw NoPathAvailable' do
      destination_amount = Ripple::Model::Amount.new(currency: 'EUR', value: '0.0001', issuer: 'r4LADqzmqQUMhgSyBLTtPMG4pAzrMDx7Yj')
      params = {
        destination_account: "r4LADqzmqQUMhgSyBLTtPMG4pAzrMDx7Yj",
        destination_amount: destination_amount.to_json,
        source_account: "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
        source_currency: 'USD'
      }
      expect { abstract.find_first_available_path(params) }.to raise_error(Ripple::NoPathAvailable)
    end


    it 'should be successful sending USD from EUR' do
      destination_amount = Ripple::Model::Amount.new(value: '0.00001', currency: 'EUR', issuer: 'r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59')

      params = {
        destination_account: "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
        destination_amount: destination_amount.to_json,
        source_currency: 'USD'
      }
      path = abstract.find_first_available_path(params)

      params = {
        destination: "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
        destination_amount: destination_amount.to_json,
        path: path
      }
      tx_hash = abstract.send_other_currency(params)
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
