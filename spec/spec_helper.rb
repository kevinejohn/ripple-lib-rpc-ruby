require File.expand_path('../../lib/ripple', __FILE__)
require 'rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.default_cassette_options = {record: :new_episodes, re_record_interval: 604800} # 7 days
end

VCR.configuration.configure_rspec_metadata!