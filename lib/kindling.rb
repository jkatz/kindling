Dir[File.join(File.dirname(__FILE__), 'kindling/**/*.rb')].sort.each { |lib| require lib }

module Kindling

  VERSION = '0.2.0'

end