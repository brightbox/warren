require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "#{File.dirname(__FILE__)}/../../../lib/warren/adapters/bunny_adapter.rb"

describe Warren::Queue::BunnyAdapter do

  before do
    # play nicely with other adapters loaded
    Warren::Queue.adapter = Warren::Queue::BunnyAdapter
  end

  describe "connection details" do

    before do
      setup_config_object
    end

    it "should override check_connection_details" do
      Warren::Queue::BunnyAdapter.methods(false).should include("check_connection_details")
    end
    
    it "should require a username" do
      @options.delete(:user)
      lambda {
        Warren::Connection.new(@config)
      }.should raise_error(Warren::Connection::InvalidConnectionDetails, "User not specified")
    end

    it "should require a password" do
      @options.delete(:pass)
      lambda {
        Warren::Connection.new(@config)
      }.should raise_error(Warren::Connection::InvalidConnectionDetails, "Pass not specified")
    end

    it "should require a vhost" do
      @options.delete(:vhost)
      lambda {
        Warren::Connection.new(@config)
      }.should raise_error(Warren::Connection::InvalidConnectionDetails, "Vhost not specified")
    end
  end

  describe "subscribe" do
    it "should override subscribe" do
      Warren::Queue::BunnyAdapter.methods(false).should include("subscribe")
    end

    it "should accept a subscribe block with one argument" do
      blk = lambda do |one|
        one.should == "my message"
      end

      send_headers_to_bunny_with &blk
    end

    it "should accept a subscribe block with two arguments" do
      blk = lambda do | message, headers |
        message.should == "my message"
        headers.should == {:some => :header}
      end

      headers = {
        :payload => "my message",
        :some => :header
      }
      Warren::Queue::BunnyAdapter.__send__(:handle_bunny_message, headers, &blk)
    end

    def send_headers_to_bunny_with &blk
      headers = {
        :payload => "my message",
        :some => :header
      }
      Warren::Queue::BunnyAdapter.__send__(:handle_bunny_message, headers, &blk)
    end
  end

  protected

  def setup_config_object
    @options = {
      :host => "localhost",
      :user => "rspec",
      :pass => "password",
      :vhost => "/",
      :logging => false
    }
    @config = {
      :development => @options
    }
  end

end
