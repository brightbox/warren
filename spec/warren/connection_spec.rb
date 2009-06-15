require File.dirname(__FILE__) + '/../spec_helper'

describe Warren::Connection do

  before(:each) do
    setup_adapter
  end

  it "should read from warren.yml" do
    setup_config_file

    Warren::Connection.new
  end

  it "should read from an arbitrary file" do
    File.should_receive(:exists?).with("my_awesome_config.yml").and_return(true)
    YAML.should_receive(:load_file).with("my_awesome_config.yml").and_return({"development" => {}})

    Warren::Connection.new("my_awesome_config.yml")
  end

  describe "parsing config with file" do

    before do
      setup_config_file
    end

    it "should parse the right config out" do
      conn = Warren::Connection.new
      WARREN_ENV.should == "development"
      conn.instance_variable_get("@options").should == {
        :user => "rspec",
        :pass => "password",
        :host => "localhost",
        :logging => false,
      }
    end
    
    it "should raise if no details for current environment" do
      silently { WARREN_ENV = "rspec" }
      
      lambda { Warren::Connection.new }.
      should raise_error(
        Warren::Connection::InvalidConnectionDetails,
        "No details for current environment 'rspec'"
      )
      
      silently { WARREN_ENV = "development" }
    end

    it "should symbolize keys in a hash" do
      conn = Warren::Connection.new
      hash = {"one" => "two", "three" => {"four" => 7}, :five => "six"}
      conn.send(:symbolize_keys, hash).should == {
        :one   => "two",
        :three => {:four => 7},
        :five  => "six"
      }
    end

    it "should raise if no adapter set to check against" do
      Warren::Queue.adapter = nil
      lambda { Warren::Connection.new }.
      should raise_error(Warren::Queue::NoAdapterSet)
    end

    it "should successfully check against adapter" do
      _adapter = mock 'queue', :check_connection_details => true
      _adapter.should_receive(:check_connection_details)
      Warren::Queue.adapter = _adapter
      
      Warren::Connection.new
    end

    it "should raise errors for missing connection details" do
      _adapter = stub 'queue', :check_connection_details => ["one", "two"]

      Warren::Connection.new
    end

    it "should raise errors for other prerequisits in the adapter" do
      Adapter = Class.new(Warren::Queue) do
        def self.check_connection_details params
          raise Warren::Connection::InvalidConnectionDetails, "Missing prerequisites"
        end
      end

      lambda { Warren::Connection.new }.
      should raise_error(Warren::Connection::InvalidConnectionDetails, "Missing prerequisites")
    end

  end

  def setup_config_file
    config_file = "#{File.dirname($0)}/config/warren.yml"
    File.should_receive(:exists?).with(config_file).and_return(true)
    YAML.should_receive(:load_file).with(config_file).and_return(yaml_data)
  end

  def setup_adapter
    _adapter = stub 'queue'
    Warren::Queue.adapter = _adapter
  end

  def yaml_data
    {
      "development" => {
        "host" => "localhost",
        "user" => "rspec",
        "pass" => "password",
        "logging" => false
      },
      "test" => {
        "host" => "localhost-test",
        "user" => "rspec-test",
        "pass" => "password-test",
        "logging" => true
      }
    }
  end

end
