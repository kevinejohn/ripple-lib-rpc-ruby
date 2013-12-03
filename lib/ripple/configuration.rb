require 'faraday'
require File.expand_path('../version', __FILE__)

module Ripple
  # Defines constants and methods related to configuration
  module Configuration
    # An array of valid keys in the options hash when configuring a {Ripple::API}
    VALID_OPTIONS_KEYS = [
      :client_account,
      :client_secret,
      :user_agent,
      :endpoint,
      :adapter,
      :connection_type
    ].freeze

    # By default, don't set an account
    DEFAULT_CLIENT_ACCOUNT = nil

    # By default, don't set a secret
    DEFAULT_CLIENT_SECRET = nil

    # The user agent that will be sent to the API endpoint if none is set
    DEFAULT_USER_AGENT = "Ripple Ruby Gem #{Ripple::VERSION}".freeze

    DEFAULT_ENDPOINT = nil

    DEFAULT_CONNECTION = 'RPC'

    # The adapter that will be used to connect if none is set
    #
    # @note The default faraday adapter is Net::HTTP.
    DEFAULT_ADAPTER = Faraday.default_adapter

    # @private
    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Reset all configuration options to defaults
    def reset
      self.client_account        = DEFAULT_CLIENT_ACCOUNT
      self.client_secret         = DEFAULT_CLIENT_SECRET
      self.user_agent            = DEFAULT_USER_AGENT
      self.endpoint              = DEFAULT_ENDPOINT
      self.adapter               = DEFAULT_ADAPTER
      self.connection_type       = DEFAULT_CONNECTION
    end
  end
end
