Gem::Specification.new do |s|
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'awesome_print'

  s.add_runtime_dependency 'faraday'
  s.add_runtime_dependency 'faraday_middleware'
  s.add_runtime_dependency 'multi_json'
  s.add_runtime_dependency 'hashie'

  s.name        = 'ripple_lib_rpc_ruby'
  s.version     = '0.0.0'
  s.date        = '2013-11-05'
  s.summary     = "ripple-lib"
  s.description = "A client interface to the Ripple network"
  s.authors     = ["Kevin Johnson"]
  s.email       = 'kevin@ripple.com'
  s.files       = ["lib/ripple_lib_rpc_ruby.rb"]
  s.homepage    =
    'http://rubygems.org/gems/ripple_lib_rpc_ruby'
  s.license       = 'MIT'
end
