Dir[File.join(File.dirname(__FILE__), 'kindling/**/*.rb')].sort.each { |lib| require lib }

module Kindling

  class Kindling

    def self.initialize_from_file(file_path)
      # self.new(Kindling::Base.initialize_connection_from_file(file_path))
    end

    def initialize()
      #@connection = 
    end

  end

end