require 'rubygems'
require 'uri'
require 'net/http'
require 'net/https'
require 'nokogiri'

module Kindling

  class Base

    DEFAULT_CONNECTION_OPTIONS = {
      :domain => '.campfirenow.com',
      :port => 80,
      :ssl => false
    }

    class << self

      def connection
        @connection
      end

      # configures the connection for the Campfire lobby we are connecting to
      #
      # * +lobby+: the name of the Campfire lobby we want to connect to
      # * +options:+
      #   * +:ssl+: true if we are connection over SSL.  Defaults to false
      def initialize_connection(lobby, options={})
        options = DEFAULT_CONNECTION_OPTIONS.merge(options)
        url = URI.parse(uri_for(lobby, options))
        @connection = {
          :host => url.host,
          :port => url.port,
          :ssl => ssl?(url.scheme)
        }
      end


      # configures the connection for the Campfire lobby we are connecting to from
      # a Yaml configuration file
      def initialize_connection_from_file(file_path)
        raise Errno::ENOENT unless File.exists?(file_path)
        file = File.open(file_path)
        config = symbolize_keys(YAML::load(file.read))
        self.initialize_connection(config[:lobby], config[:options])
      end

    private

      def ssl?(scheme)
        scheme == 'https'
      end

      def symbolize_keys(hash)
        return hash unless hash.kind_of?(Hash)
        symbol_hash = {}
        hash.each { |k,v| symbol_hash[k.to_sym] = symbolize_keys(v) }
        symbol_hash
      end

      def uri_for(lobby, options)
        scheme = ssl?(options[:ssl]) ? 'https' : 'http'
        domain = lobby + options[:domain]
        port = options[:port]
        [scheme, '://', domain, ':', port].join
      end

    end

  end

end
