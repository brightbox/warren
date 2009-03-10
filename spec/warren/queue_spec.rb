require File.dirname(__FILE__) + '/../spec_helper'

describe Warren::Queue do
  
  it "should require raise exception with no connection details" do
    lambda {
      Warren::Queue.connection
    }.should raise_error(Warren::Queue::NoConnectionDetails)
  end
  
  it "should require connection details to publish" do
    lambda {
      Warren::Queue.publish("", "")
    }.should raise_error(Warren::Queue::NoConnectionDetails)
  end
  
  it "should require connection details to subscribe" do
    lambda {
      Warren::Queue.subscribe("") { true }
    }.should raise_error(Warren::Queue::NoConnectionDetails)
  end
  
  it "should set connection details" do
    conn = new_connection
    
    Warren::Queue.connection = conn
    Warren::Queue.connection.should == conn
  end
  
  it "should publish to a queue" do
    Warren::Queue.connection = new_connection
    
    Warren::Queue.should_receive(:do_connect).with(true, nil).and_return(true)
    Warren::Queue.publish("queue", "payload")
  end
  
  it "should publish to a default queue" do
    Warren::Queue.connection = new_connection(:default_queue => "queue")
    
    Warren::Queue.should_receive(:do_connect).with(true, nil).and_return(true)
    Warren::Queue.publish(:default, "payload")
  end
    
  it "should publish to a queue with a block" do
    Warren::Queue.connection = new_connection
    
    blk = Proc.new { true }
    
    Warren::Queue.should_receive(:do_connect).with(true, blk).and_return(true)
    Warren::Queue.publish("queue", "payload", &blk)
  end
  
  describe "subscribing" do
    
    it "should require a block to be passed" do
      Warren::Queue.connection = new_connection
      
      lambda {
        Warren::Queue.subscribe("queue")
      }.should raise_error(Warren::Queue::NoBlockGiven)
    end
    
    it "should subscribe to a queue" do
      Warren::Queue.connection = new_connection
      
      Warren::Queue.should_receive(:do_connect).with(false).and_return(true)
      Warren::Queue.subscribe("queue") { true }
    end
    
    it "should subscribe to the default queue" do
      Warren::Queue.connection = new_connection(:default_queue => "queue")
      
      Warren::Queue.should_receive(:do_connect).with(false).and_return(true)
      Warren::Queue.subscribe(:default) { true }
    end
    
  end
  
  private
  
  def new_connection opts = {}
    Warren::Connection.new(details.merge(opts))
  end
  
  def details
    {
      :user  => "user",
      :pass  => "pass",
      :vhost => "main",
    }
  end
  
end