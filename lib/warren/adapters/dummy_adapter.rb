require "rubygems"

class DummyAdapter < Warren::Queue
  def self.publish queue_name, payload, &blk
    puts "publishing #{payload.inspect} to #{queue_name}"
  end

  def self.subscribe queue_name, &block
    puts "subscribing to #{queue_name}"
  end
end

