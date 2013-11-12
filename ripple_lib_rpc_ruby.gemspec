Gem::Specification.new do |s|
  s.name        = 'ripple'
  s.version     = '0.0.0'
  s.date        = '2013-11-05'
  s.summary     = "ripple-lib"
  s.description = "A client interface to the Ripple network"
  s.authors     = ["Kevin Johnson"]
  s.email       = 'kevin@ripple.com'
  s.files       = ["lib/ripple.rb"]
  s.homepage    =
    'http://rubygems.org/gems/ripple_lib_rpc_ruby'
  s.license       = 'MIT'

  s.files = `git ls-files`.split("\n")
  s.require_paths = ['lib']

  s.add_runtime_dependency 'faraday_middleware'
  s.add_runtime_dependency 'hashie'

  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-nav'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
