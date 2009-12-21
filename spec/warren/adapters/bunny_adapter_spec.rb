require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "#{File.dirname(__FILE__)}/../../../lib/warren/adapters/bunny_adapter.rb"

describe Warren::Queue::BunnyAdapter do

  describe "connection details" do
    
    it "should override check_connection_details" do
      Warren::Queue::BunnyAdapter.methods(false).should include("check_connection_details")
    end
    
    it "should require a username" do
      setup_config_object
      @options.delete("user")
      lambda {
        Warren::Connection.new(@config)
      }.should raise_error(Warren::Connection::InvalidConnectionDetails, "User not specified")
    end

    it "should require a password" do
      setup_config_object
      @options.delete("pass")
      lambda {
        Warren::Connection.new(@config)
      }.should raise_error(Warren::Connection::InvalidConnectionDetails, "Pass not specified")
    end

    it "should require a vhost" do
      setup_config_object
      @options.delete("vhost")
      lambda {
        Warren::Connection.new(@config)
      }.should raise_error(Warren::Connection::InvalidConnectionDetails, "Vhost not specified")
    end
  end

  def setup_config_object
    @options = {
      "host" => "localhost",
      "user" => "rspec",
      "pass" => "password",
      "vhost" => "/",
      "logging" => false
    }
    @config = {
      "development" => @options
    }
  end

end
