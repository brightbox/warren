require File.dirname(__FILE__) + '/../spec_helper'
require "yaml"

describe Warren::Message do
  
  it "should require a payload" do
    lambda {
      Warren::Message.new
    }.should raise_error(ArgumentError)
  end
  
  it "should create new message with payload" do
    msg = Warren::Message.new("payload")
    
    msg.should be_a_kind_of(Warren::Message)
    msg.instance_variable_get(:@payload).should == "payload"
  end
  
  it "should pack up ruby data as payload" do
    msg = Warren::Message.new("payload")
    
    msg.payload.should == YAML.dump("payload")
    msg.to_s.should    == YAML.dump("payload")
  end
  
  it "shouldn't re-pack payload if already packed" do
    yml = YAML.dump("payload")
    msg = Warren::Message.new(yml)
    
    msg.payload.should == yml
    msg.to_s.should    == yml
  end
  
  it "shouldn't let you update the payload" do
    msg = Warren::Message.new("payload")
    msg.payload.should == YAML.dump("payload")
    
    lambda {
      msg.payload = "foobar"
    }.should raise_error(NoMethodError)
  end
  
end
