require 'nokogiri'

module Kindling

  class Lobby

    # setup the lobby we are going to connect to from a Yaml configuration file
    #
    # * +file_path+: the path to the config file
    def self.initialize_from_file(file_path)
      self.new(Base.initialize_connection_from_file(file_path))
    end

    attr_reader :base, :rooms

    # setup the lobby we are going to connect to by the name of the lobby
    def initialize(base, options={})
      @active = false
      @base = base.kind_of?(String) ?
        Base.initialize_connection(base, options) :
        base
      @rooms = []
    end

    # disconnect from the lobby
    def disconnect
      @base.get('/logout')
      Base.disconnect!
    end

    # connect to the lobby
    # returns an array of +Kindling::Room+ that are connectable
    def connect(email_address, password)
      response = @base.post('/login',
        :email_address => email_address,
        :password => password
      )

      doc = Nokogiri::HTML(response)
      unless doc.css('#loginForm').empty?
        Base.disconnect!
        raise ConnectionError, 'failed to connect. Please verify your connection settings and your username and password'
      else
        Base.connect!
        doc.css('table.lobby a').each { |anchor|
          anchor['href'] =~ /([0-9]+)(\/?)$/
          room_id = $1
          @rooms << Room.new(room_id, anchor.text)
        }
        @rooms
      end
    end

  private

    class ConnectionError < RuntimeError; end

  end

end
