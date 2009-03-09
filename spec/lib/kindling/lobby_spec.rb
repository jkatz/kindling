require File.dirname(__FILE__) + '/../../spec_helper'

describe Kindling::Lobby, '.initialize_from_file' do
end

describe Kindling::Lobby, '.new' do

  it 'should raise an argument error if nothing to "base" is passed' do
    lambda { Kindling::Lobby.new }.should raise_error(ArgumentError)
  end

  it 'should return an instance of Kindling::Lobby if a string is passed' do
    Kindling::Lobby.new('test').kind_of?(Kindling::Lobby).should be_true
  end

  it 'should return an instance of Kindling::Lobby if an instance of Kindling::Base is passed' do
    Kindling::Lobby.new(Kindling::Base.new('test')).kind_of?(Kindling::Lobby).should be_true
  end

end

describe Kindling::Lobby, '.initialize_from_file' do

  it 'should raise an argument error if nothing to "file_path" is passed' do
    lambda { Kindling::Lobby.initialize_from_file }.should raise_error(ArgumentError)
  end

  it 'should raise Errno::ENOENT if the file does not exist' do
    bogus_path = File.join(CONFIG_FILE_PATH, 'bogus.yml')
    lambda { Kindling::Lobby.initialize_from_file(bogus_path) }.should raise_error(Errno::ENOENT)
  end

  it 'should return an instance of Kindling::Lobby' do
    path = File.join(CONFIG_FILE_PATH, 'kindling.yml')
    Kindling::Lobby.initialize_from_file(path).kind_of?(Kindling::Lobby).should be_true
  end

end