require "rubygems"
require File.expand_path(File.dirname(__FILE__) + "/../lib/warren")

Signal.trap("INT") { exit! }
Signal.trap("TERM") { exit! }

# Setup our own connection before generating the queue object
conn = Warren::Connection.new({
  :user => "caius",
  :pass => "caius",
  :vhost => "/",
  :default_queue => "main"
})
# Set the connection for the queue
Warren::Queue.connection = conn

100.times do | i |
  puts i
  sleep 0.1
  Warren::Queue.publish(:default, "Message no #{i}") { puts "sent ##{i}" }
end