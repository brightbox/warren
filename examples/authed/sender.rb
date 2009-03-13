require "rubygems"
require File.expand_path(File.dirname(__FILE__) + "/../../lib/warren")

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

# Set the secret key
require File.expand_path(File.dirname(__FILE__) + "/secret")
Warren::MessageFilter::SharedSecret.key = SUPER_SECRET_KEY

# And add the filter
Warren::MessageFilter << Warren::MessageFilter::SharedSecret

# Push a message onto the queue
p Warren::Queue.publish(:default, data )
