require File.dirname(__FILE__) + '/../../spec_helper'

describe Kindling::Base do

  it 'should not set @connection if no initialize_from_* methods are called' do
    Kindling::Base.connection.should be_nil
  end

end

describe Kindling::Base, 'DEFAULT_CONNECTION_OPTIONS' do

  it 'should return ".campfirenow.com" for :domain' do
    Kindling::Base::DEFAULT_CONNECTION_OPTIONS[:domain].should == '.campfirenow.com'
  end

  it 'should return 80 for :port' do
    Kindling::Base::DEFAULT_CONNECTION_OPTIONS[:port].should == 80
  end

  it 'should return false for :ssl' do
    Kindling::Base::DEFAULT_CONNECTION_OPTIONS[:ssl].should be_false
  end

end

describe Kindling::Base, '.initialize_connection' do

  it 'should exist' do
    Kindling::Base.respond_to?(:initialize_connection).should be_true
  end

  it 'should return an ArgumentError if "lobby" is not passed' do
    lambda { Kindling::Base.initialize_connection }.should raise_error(ArgumentError)
  end

  it 'should return a hash with "test" as the lobby parameter' do
    Kindling::Base.initialize_connection('test').kind_of?(Hash).should be_true
  end

  describe 'with a lobby parameter' do

    before(:each) do
      @connection = Kindling::Base.initialize_connection('test')
    end

    it 'should set Kindling::Base.connection' do
      Kindling::Base.connection.should_not be_nil
    end

    it 'should have Kindling::Base.connection[:host] return "test.campfirenow.com"' do
      @connection[:host].should == "test.campfirenow.com"
    end

    it 'should have Kindling::Base.connection[:port] return 80' do
      @connection[:port].should == 80
    end

    it 'should have Kindling::Base.connection[:ssl] return false' do
      @connection[:ssl].should be_false
    end

  end

end

describe Kindling::Base, '.initialize_connection_from_file' do

  it 'should exist' do
    Kindling::Base.respond_to?(:initialize_connection_from_file).should be_true
  end

  it 'should raise Errno::ENOENT if the file does not exist' do
    bogus_path = File.join(CONFIG_FILE_PATH, 'bogus.yml')
    lambda { Kindling::Base.initialize_connection_from_file(bogus_path) }.should raise_error(Errno::ENOENT)
  end

  describe 'with a proper config file' do

    before(:each) do
      @path = File.join(CONFIG_FILE_PATH, 'kindling.yml')
      @connection = Kindling::Base.initialize_connection_from_file(@path)
    end

    it 'should return a hash' do
      @connection.kind_of?(Hash).should be_true
    end

    it 'should set Kindling::Base.connection' do
      Kindling::Base.connection.should_not be_nil
    end

    it 'should have Kindling::Base.connection[:host] return "test.campfirenow.com"' do
      @connection[:host].should == "test.campfirenow.com"
    end

    it 'should have Kindling::Base.connection[:port] return 80' do
      @connection[:port].should == 80
    end

    it 'should have Kindling::Base.connection[:ssl] return false' do
      @connection[:ssl].should be_false
    end

  end

end