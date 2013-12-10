require File.expand_path('../../spec_helper', __FILE__)
require 'json'
require 'digest/md5'
require 'pry-nav'

describe Ripple::Federation do
  let(:federation){ Ripple::Federation.new }

  context '#bridge' do
    it "should be successful" do
      resp = federation.service_declaration("alipay.ripple.com")
      puts resp.inspect
      resp.should_not be_nil
    end
  end

  context '#service_request' do
    it "should be successful" do
      params = {
        url: 'https://alipay.ripple.com/alipaybridge',
        domain: 'alipay.ripple.com',
        destination: 'support@alipay.com'
      }
      resp = federation.service_request(params)
      puts resp.to_json
      #resp.should_not be_nil
    end
  end

  context '#service_quote' do
    it "should be successful" do
      params = {
        url: 'https://alipay.ripple.com/alipaybridge',
        domain: 'alipay.ripple.com',
        destination: 'support@alipay.com',
        amount: '0.01',
        currency: 'CNY',
        extra_fields: {fullname: 'Full Name'}
      }
      quote = federation.service_quote(params)
      puts quote.to_json
      #resp.should_not be_nil
    end

    it "should fail from missing extra_field" do
      params = {
        url: 'https://alipay.ripple.com/alipaybridge',
        domain: 'alipay.ripple.com',
        destination: 'support@alipay.com',
        amount: '0.01',
        currency: 'CNY',
        #extra_fields: {fullname: 'Full Name'}
      }
      expect { federation.service_quote(params) }.to raise_error(Ripple::FederationError)
    end
  end

  context '#invoice_verify' do
    it "should be successful" do
      params = {
        url: 'https://alipay.ripple.com/alipaybridge',
        invoice_id: '2e23679a7fd97492003daf6e8fbfec940fd0f85829169c5124c9b4f61ae4fec4'
      }
      resp = federation.invoice_verify(params)
      puts resp.to_json
    end

    it "should fail" do
      params = {
        url: 'https://alipay.ripple.com/alipaybridge',
        invoice_id: '3e23679a7fd97492003daf6e8fbfec940fd0f85829169c5124c9b4f61ae4fec4'
      }
      expect { federation.invoice_verify(params) }.to raise_error(Ripple::FederationError)
    end
  end
end
