require File.dirname(__FILE__) + '/../spec_helper'

describe Warren::Queue do
  
  describe "connection" do
    
    before(:all) do
      @conn = stub 'connection'
    end
    
    it "should create a new Warren::Connection if one doesn't exist" do
      Warren::Connection.should_receive(:new).and_return(@conn)
      
      Warren::Queue.connection.should == @conn
    end
    
    it "should only create a connection once" do
      # Already created the connection object in the first it
      Warren::Connection.should_not_receive(:new)
      
      Warren::Queue.connection.should == @conn
      Warren::Queue.connection.should == @conn
    end
  end

  describe "adapter" do

    before(:each) do
      @adapter = mock 'adapter', :publish => "publish", :subscribe => "subscribe"
      Warren::Queue.adapter = @adapter
    end

    it "should have an adapter set" do
      Warren::Queue.adapter.should == @adapter
    end

    it "should have a publish method" do
      my_adapter = mock 'adapter'
      Warren::Queue.adapter = my_adapter

      lambda { Warren::Queue.publish }.should \
      raise_error(Warren::Queue::InvalidAdapter, "publish method missing")
    end

    it "should have a subscribe method" do
      my_adapter = mock 'adapter'
      Warren::Queue.adapter = my_adapter
      
      Warren::Queue.adapter.should == my_adapter

      lambda { Warren::Queue.subscribe}.should \
      raise_error(Warren::Queue::InvalidAdapter, "subscribe method missing")
    end

    it "should pass publish through to the adapter" do
      @adapter.should_receive(:publish)
      Warren::Queue.publish.should == "publish"
    end

    it "should pass arguments through to adapter#publish" do
      @adapter.should_receive(:publish).with("foo", "bar")

      Warren::Queue.publish("foo", "bar").should == "publish"
    end

    it "should pass a block through to adapter#publish" do
      block = lambda { true }
      @adapter.should_receive(:publish).with("foo", "bar", block)

      Warren::Queue.publish("foo", "bar", block).should == "publish"
    end

    it "should pass subscribe through to the adapter" do
      @adapter.should_receive(:subscribe)
      Warren::Queue.subscribe.should == "subscribe"
    end

    it "should pass arguments through to adapter#subscribe" do
      @adapter.should_receive(:subscribe).with("foo", "bar")

      Warren::Queue.subscribe("foo", "bar").should == "subscribe"
    end

    it "should pass a block through to adapter#subscribe" do
      block = lambda { true }
      @adapter.should_receive(:subscribe).with("foo", "bar", block)

      Warren::Queue.subscribe("foo", "bar", block).should == "subscribe"
    end
  end
  
  describe "logger" do
    
    before(:each) do
      Warren::Queue.logger = nil
    end
    
    it "should have a default logger" do
      Warren::Queue.logger.should_not be_nil
      Warren::Queue.logger.should be_a_kind_of(Logger)
    end
    
    it "should allow you to set a custom logger" do
      log = mock(Logger)

      Warren::Queue.logger = log
      
      Warren::Queue.logger.should_not be_nil
      Warren::Queue.logger.should == log
    end
    
  end
end