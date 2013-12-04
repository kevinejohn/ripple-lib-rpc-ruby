require File.expand_path('../../spec_helper', __FILE__)
require 'json'
require 'digest/md5'
require 'pry-nav'

describe Ripple::Federation do
  # before :all do
  #   Ripple.configure do |config|
  #     config.endpoint = 'http://s1.ripple.com:51234/'
  #     config.client_account = "r4LADqzmqQUMhgSyBLTtPMG4pAzrMDx7Yj"
  #     config.client_secret = "ssm5HPoeEZYJWvkJvQW9ro6e6hW9m"
  #   end
  # end

  let(:federation){ Ripple::Federation.new }

  context '#bridge' do
    it "should be successful" do
      resp = federation.service_declaration("alipay.ripple.com")
      #puts resp.inspect
      resp.should_not be_nil
    end
  end
end
