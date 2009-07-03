require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "#{File.dirname(__FILE__)}/../../../lib/warren/adapters/test_adapter.rb"

describe TestAdapter do

  before(:all) do
    @file_name = "#{WARREN_ROOT}/tmp/warren.txt"
  end

  it "should return true from publish without a tmp file" do
    TestAdapter.publish(:queue_name, :payload).should == true
  end

  it "should return true from publish with a tmp file which doesn't say \"FAIL\"" do
    File.should_receive(:exists?).with(@file_name).and_return(true)
    File.should_receive(:read).with(@file_name, 4).and_return("blah")

    TestAdapter.publish(:queue_name, :payload).should == true
  end

  it "should raise an error when tmp file exists and says \"FAIL\"" do
    File.should_receive(:exists?).with(@file_name).and_return(true)
    File.should_receive(:read).with(@file_name, 4).and_return("FAIL")

    lambda { TestAdapter.publish(:queue_name, :payload) }.
    should raise_error(TestAdapter::ConnectionFailed)
  end

end