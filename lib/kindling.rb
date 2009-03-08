Dir[File.join(File.dirname(__FILE__), 'kindling/**/*.rb')].sort.each { |lib| require lib }

module Kindling

  class Kindling

    def self.initialize_from_file(file_path)
      self.new(Base.initialize_connection_from_file(file_path))
    end

    def initialize(base, options={})
      @base = base.kind_of?(String) ?
        Base.initialize_connection(base, options) :
        base
    end

  end

end