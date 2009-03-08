require File.dirname(__FILE__) + '/../../spec_helper'

describe Kindling::Kindling, '.initialize_from_file' do
end

describe Kindling::Kindling, '.new' do

  it 'should raise an argument error if nothing to "base" is passed' do
    lambda { Kindling::Kindling.new }.should raise_error(ArgumentError)
  end

  it 'should return an instance of Kindling::Kindling if a string is passed' do
    Kindling::Kindling.new('test').kind_of?(Kindling::Kindling).should be_true
  end

  it 'should return an instance of Kindling::Kindling if an instance of Kindling::Base is passed' do
    Kindling::Kindling.new(Kindling::Base.new('test')).kind_of?(Kindling::Kindling).should be_true
  end

end

describe Kindling::Kindling, '.initialize_from_file' do

  it 'should raise an argument error if nothing to "file_path" is passed' do
    lambda { Kindling::Kindling.initialize_from_file }.should raise_error(ArgumentError)
  end

  it 'should raise Errno::ENOENT if the file does not exist' do
    bogus_path = File.join(CONFIG_FILE_PATH, 'bogus.yml')
    lambda { Kindling::Kindling.initialize_from_file(bogus_path) }.should raise_error(Errno::ENOENT)
  end

  it 'should return an instance of Kindling::Kindling' do
    path = File.join(CONFIG_FILE_PATH, 'kindling.yml')
    Kindling::Kindling.initialize_from_file(path).kind_of?(Kindling::Kindling).should be_true
  end

end