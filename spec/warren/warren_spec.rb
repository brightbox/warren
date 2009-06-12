require File.dirname(__FILE__) + '/../spec_helper'

describe Warren do
  
  it "should have a default environment" do
    WARREN_ENV.should == "development"
  end

end
