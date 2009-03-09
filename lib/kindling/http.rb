require 'net/http'
require 'net/https'

module Kindling

  class HTTP

    attr_reader :data

    class << self

      def request(type, path, data={}, &block)
        request = constantize(type).new(path)
        request.body = query_string_encode(data)
        request.add_field 'User-Agent', "Kindling/#{Kindling::VERSION} (http://github.com/jkatz/kindling)"
        request.add_field 'Cookie', Base.cookie.to_s
        request.add_field 'Content-Type', 'application/x-www-form-urlencoded'
        yield(request) if block
        perform_request(request)
      end

    private

      # :nodoc: based upon the Rails 'constantize' method
      def constantize(type)
        type[0] = type[0].chr.upcase
        names = "Net::HTTP::#{type}".split('::')
        constant = Object
        names.each { |name|
          constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
        }
        constant
      end

      # :nodoc:
      def methods
        [:get, :post]
      end

      # :nodoc:
      def method_missing(method, *args, &block)
        super unless methods.include?(method.to_sym)
        args.unshift(method.to_s)
        send(:request, *args, &block)
      end

      # :nodoc:
      def perform_request(request)
        http = Net::HTTP.new(
          Base.connection[:host],
          Base.connection[:port]
        )

        if Base.connection[:ssl]
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        http.request(request) do |response|
          Base.cookie = response['set-cookie'] # if response['set-cookie']
          case response
          when Net::HTTPRedirection
            url = URI.parse(response['location'])
            return self.get(url.path)
          when Net::HTTPSuccess
            return response.body
          end
        end
      end

      # :nodoc:
      def query_string_encode(data)
        query = []
        data.each { |k,v| query << query_type(k, v) }
        query.join('&')
      end

      # :nodoc:
      def query_string_encode_array(key, array)
        query = []
        array.each do |v|
          url_key = "#{key.to_s}[]"
          query << query_type(url_key, v)
        end
        query.join('&')
      end

      # :nodoc:
      def query_string_encode_hash(key, hash)
        query = []
        hash.each do |k,v|
          url_key = "#{key.to_s}[#{k.to_s}]"
          query << query_type(url_key, v)
        end
        query.join('&')
      end

      # :nodoc:
      def query_type(key, value)
        case value
        when Array
          query_string_encode_array(key, value)
        when Hash
          query_string_encode_hash(key, value)
        else
          [key.to_s, value.to_s].join('=')
        end
      end

    end

  end

end
