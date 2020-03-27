require 'httparty'
require 'json'

module Freshworks
  class Configuration
    attr_accessor :base_uri, :account_api_key, :event_api_key, :event_auth_key

    def initialize
      self.account_api_key = nil
      self.event_api_key = nil
      self.event_auth_key = nil
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end

  def self.full_endpoint_uri(base_uri, version_uri, *params)
    base = self.uri(base_uri, version_uri)

    params.flatten!
    params.each { |param| base << '/' + param } unless params.empty?

    base
  end

  def self.uri(base_uri, version_uri)
    base_uri + version_uri
  end

  def self.api_key_uri
    '?api_key=' + Freshworks.configuration.account_api_key
  end

  def self.to_records_json(objects)
    "{\"records\": #{Array(objects).map(&:serialize)}}".to_s.delete('\\').gsub('"{', '{').gsub('}"', '}')
  end

  def self.gem_root
    File.expand_path('../..', __FILE__)
  end
end

require_relative 'freshworks/serializable'
require_relative 'freshworks/request_helper'
require_relative 'freshworks/base'
require_relative 'freshworks/user'
require_relative 'freshworks/account'
require_relative 'freshworks/event'
require_relative 'freshworks/response'
require_relative 'freshworks/metric'
