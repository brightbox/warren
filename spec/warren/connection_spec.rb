require File.dirname(__FILE__) + '/../spec_helper'

describe Warren::Connection do
  
  before(:each) do
    @file = stub 'io', :read => yaml_data
    setup_adapter
  end
    
  it "should read from a config file" do
    YAML.should_receive(:load).with("#{File.dirname($0)}/config/warren.yml").and_return({"development" => {}})

    Warren::Connection.new
  end

  it "should parse the right config out" do    
    conn = Warren::Connection.new(@file)
    conn.instance_variable_get("@opts").should == {
      :host    => "localhost",
      :user    => "rspec",
      :pass    => "password",
      :logging => false
    }
  end
  
  it "should symbolize keys in a hash" do
    conn = Warren::Connection.new(@file)
    hash = {"one" => "two", "three" => "four", :five => "six"}
    conn.send(:symbolize_keys, hash).should == {
      :one   => "two",
      :three => "four",
      :five  => "six"
    }
  end
  
  it "should raise if no adapter set to check against" do
    Warren::Queue.adapter = nil
    lambda {
      Warren::Connection.new(@file)
    }.should raise_error(Warren::Queue::NoAdapterSet)
  end
  
  it "should successfully check against adapter" do
    _adapter = stub 'queue', :check_connection_details => true
    
    Warren::Connection.new(@file)
  end
  
  it "should raise errors for missing connection details" do
    _adapter = stub 'queue', :check_connection_details => ["one", "two"]
    
    Warren::Connection.new(@file)
  end
  
  it "should raise errors for other prerequisits in the adapter" do
    Adapter = Class.new(Warren::Queue) do
      def self.check_connection_details params
        raise Warren::Connection::InvalidConnectionDetails, "Missing prerequisites"
      end
    end

    lambda {
      Warren::Connection.new(@file)
    }.should raise_error(Warren::Connection::InvalidConnectionDetails, "Missing prerequisites")
  end

  def setup_adapter
    _adapter = stub 'queue'
    Warren::Queue.adapter = _adapter
  end

  def yaml_data
    a = <<-EOF
---
development:
  host: localhost
  user: rspec
  pass: password
  logging: false

test:
  host: localhost
  user: rspec
  pass: password
  logging: true
EOF
  end

end
