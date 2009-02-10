require "rubygems"
require File.expand_path(File.dirname(__FILE__) + "/../warren")

Signal.trap("INT") { AMQP.stop { EM.stop } }
Signal.trap("TERM") { AMQP.stop { EM.stop } }

# Setup our own connection before generating the queue object
conn = Warren::Connection.new(
  :user => "caius",
  :pass => "caius",
  :vhost => "/",
  :default_queue => "main"
)
# Set the connection for the queue
Warren::Queue.set_connection(conn)
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
# And then push a message onto the queue
Warren::Queue.publish("main", data)
