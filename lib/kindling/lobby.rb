module Kindling

  class Lobby

    # setup the lobby we are going to connect to from a Yaml configuration file
    #
    # * +file_path+: the path to the config file
    def self.initialize_from_file(file_path)
      self.new(Base.initialize_connection_from_file(file_path))
    end

    # setup the lobby we are going to connect to by the name of the lobby
    def initialize(base, options={})
      @base = base.kind_of?(String) ?
        Base.initialize_connection(base, options) :
        base
    end

    attr_reader :base

    # connect to the lobby
    def connect(email_address, password)
      @base.post('/login',
        :email_address => email_address,
        :password => password
      )
    end

  end

end