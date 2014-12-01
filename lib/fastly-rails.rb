require "fastly-rails/engine"
require "fastly-rails/client"
require "fastly-rails/configuration"
require "fastly-rails/errors"

module FastlyRails

  attr_reader :client, :configuration

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end

  def self.service_id
    raise NoServiceIdProvidedError if configuration.invalid_service_id?
    configuration.service_id
  end

  def self.client
    raise NoAPIKeyProvidedError unless configuration.authenticatable?

    @client ||= Client.new(
      :api_key  => configuration.api_key,
      :user     => configuration.user,
      :password => configuration.password,
    )
  end

  def self.purge_everything!
    client.purge_everything!
  end

end
