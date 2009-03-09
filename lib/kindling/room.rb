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
      url = ['/room', @id].join('/')
      HTTP.get(url)
      @active = true
    end

    # leave a room
    def leave
      url = ['/room', @id, 'leave'].join('/')
      HTTP.post(url)
      @active = false
    end

    # say something in the room
    def say(message)
      options = {
        :message => message,
        :t => Time.now.to_i
      }
      url = ['/room', @id, 'speak'].join('/')
      HTTP.post(url, options) do |request|
        request.add_field 'X-Requested-With', 'XMLHttpRequest'
        request.add_field 'X-Prototype-Version', '1.6.1.1'
      end
    end

  end

end
