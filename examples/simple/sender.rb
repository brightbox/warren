require "rubygems"
require File.expand_path(File.dirname(__FILE__) + "/../lib/warren")

Signal.trap("INT") { exit! }
Signal.trap("TERM") { exit! }

# Setup our own connection before generating the queue object
conn = Warren::Connection.new(
  :user => "caius",
  :pass => "caius",
  :vhost => "/",
  :default_queue => "main"
)
# Set the connection for the queue
Warren::Queue.connection = conn
# Generate some data to send
data = {
  :people => [
    :fred => {
      :age => 25,
      :location => "Leeds"
    },
    :george => {
      :age => 32,
      :location => "London"
    }
  ]
}
# Push a message onto the queue
p Warren::Queue.publish(:default, data )

# And then push a message onto the queue, returning "foo"
p Warren::Queue.publish(:default, data) { "foo" }
