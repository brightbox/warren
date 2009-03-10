require File.dirname(__FILE__) + '/../spec_helper'

describe Warren::Connection do
  
  before(:each) do
    @c = Warren::Connection.new(details)
  end
  
  it "should require a username" do
    lambda {
      Warren::Connection.new(details.except(:user))
    }.should raise_error(Warren::Connection::InvalidConnectionDetails)
  end
  
  it "should require a password" do
    lambda {
      Warren::Connection.new(details.except(:pass))
    }.should raise_error(Warren::Connection::InvalidConnectionDetails)
  end
  
  it "should require a queue name if none specified" do
    lambda {
      conn = Warren::Connection.new(details)
      conn.queue_name
    }.should raise_error(Warren::Connection::InvalidConnectionDetails)
  end
  
  it "should return a default host" do
    @c.options[:host].should == "localhost"
  end
  
  it "should return a given host" do
    c = Warren::Connection.new(details.merge({:host => "caius"}))
    c.options[:host].should == "caius"
  end
  
  it "should return a default port" do
    @c.options[:port].should == 5672
  end
  
  it "should return a given port" do
    c = Warren::Connection.new(details.merge({:port => 1}))
    c.options[:port].should == 1
  end
  
  it "should return a default logging param" do
    @c.options[:logging].should == false
  end
  
  it "should return a given logging param" do
    c = Warren::Connection.new(details.merge({:logging => true}))
    c.options[:logging].should == true
  end

  it "should return the given queue name" do
    conn = Warren::Connection.new(details.merge({:default_queue => "queue"}))
    conn.queue_name.should == "queue"
  end

  private

  def details
    {
      :user  => "user",
      :pass  => "pass",
      :vhost => "main",
    }
  end
  
end
