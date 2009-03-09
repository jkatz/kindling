require 'rubygems'
require 'uri'
require 'nokogiri'

module Kindling

  class Base

    DEFAULT_CONNECTION_OPTIONS = {
      :domain => '.campfirenow.com',
      :port => 80,
      :ssl => false
    }

    class << self

      def connect!
        @connected = true
      end

      def connected?
        !!@connected
      end

      def connection
        @connection
      end

      def cookie
        @cookie
      end

      def cookie=(cookie)
        @cookie = cookie
      end

      def disconnect!
        @connected = false
      end

      # configures the connection for the Campfire lobby we are connecting to
      #
      # * +lobby+: the name of the Campfire lobby we want to connect to
      # * +options:+
      #   * +:ssl+: true if we are connection over SSL.  Defaults to false
      def initialize_connection(lobby, options={})
        options = DEFAULT_CONNECTION_OPTIONS.merge(options)
        url = URI.parse(url_for(lobby, options))
        @connection = {
          :host => url.host,
          :port => url.port,
          :ssl => ssl?(url.scheme)
        }
        self.new(lobby)
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

      def url_for(lobby, options)
        scheme = options[:ssl] ? 'https' : 'http'
        domain = lobby + options[:domain]
        port = options[:port]
        [scheme, '://', domain, ':', port].join
      end

    end

    def initialize(lobby)
      @lobby = lobby
    end

    def get(path, options={})
      HTTP.get(path, options)
    end

    def post(path, options={})
      data = HTTP.post(path, options)
    end

  end

end
