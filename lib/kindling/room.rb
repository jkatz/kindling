require 'nokogiri'

module Kindling

  class Room

    def initialize(id, name)
      @id = id
      @name = name
    end

    # returns true if we have joined this room, otherwise false
    def active?
      !!@active
    end

    # join a room
    def join
      HTTP.get(path_for())
      @active = true
    end

    # leave a room
    def leave
      HTTP.post(path_for('leave'))
      @active = false
    end

    # say something in the room
    def say(message)
      raise ConnectionError, 'you are not connected to this room' unless @active

      data = {
        :message => message,
        :t => Time.now.to_i
      }

      HTTP.post(path_for('speak'), data) do |request|
        request.add_field 'X-Requested-With', 'XMLHttpRequest'
        request.add_field 'X-Prototype-Version', '1.6.1.1'
      end
    end

  private

    def path_for(action=nil)
      path = ['/room', @id]
      path << action if action
      path.join('/')
    end

    class ConnectionError < RuntimeError; end

  end

end
