require File.dirname(__FILE__) + '/../spec_helper'

# Needed for some tests later on
class Foo
  def self.pack msg
    msg
  end

  def self.unpack msg
    msg
  end
end

describe Warren::MessageFilter do

  before(:each) do
    Warren::MessageFilter.reset_filters
  end

  describe "Managing Filters" do
    it "should have YAML as a filter by default" do
      fs = Warren::MessageFilter.filters

      fs.should have(1).element
      fs.first.should == Warren::MessageFilter::Yaml
    end

    it "should add additional filters to the stack" do
      Warren::MessageFilter.should respond_to(:<<)
      Warren::MessageFilter << Foo
      fs = Warren::MessageFilter.filters

      fs.should have(2).elements
      fs.first.should == Warren::MessageFilter::Yaml
      fs.last.should == Foo
    end
  end

  describe "calling filters to send message" do

    it "should YAML by default" do
      @msg = "message"
      Warren::MessageFilter::Yaml.should_receive(:pack).with(@msg).and_return("yamled")

      Warren::MessageFilter.pack(@msg)
    end

    it "should call each filter in turn when packing" do
      @msg = "message"

      Foo.should_receive(:pack).with(@msg).and_return("fooed")
      Warren::MessageFilter::Yaml.should_receive(:pack).with("fooed").and_return("yamled")

      Warren::MessageFilter << Foo

      Warren::MessageFilter.pack(@msg).should == "yamled"
    end

  end

  describe "calling filters to unpack message" do
    it "should un-YAML by default" do
      @msg = "yamled"

      Warren::MessageFilter::Yaml.should_receive(:unpack).with("yamled").and_return("message")

      Warren::MessageFilter.unpack(@msg).should == "message"
    end

    it "should run all unpack filters" do
      @msg = "yamled message"

      Warren::MessageFilter::Yaml.should_receive(:unpack).with("yamled message").and_return("fooed")
      Foo.should_receive(:unpack).with("fooed").and_return("message")

      Warren::MessageFilter << Foo
      Warren::MessageFilter.filters.should == [Warren::MessageFilter::Yaml, Foo]

      Warren::MessageFilter.unpack(@msg).should == "message"
    end
  end

end

