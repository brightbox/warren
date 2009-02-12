require File.dirname(__FILE__) + '/../spec_helper'

describe Warren::Message do
  
  it "should require a payload" do
    lambda {
      Warren::Message.new
    }.should raise_errorg(ArgumentError)
  end
  
end
