require "rubygems"
require File.expand_path(File.dirname(__FILE__) + "/../../lib/warren")

Signal.trap("INT") { AMQP.stop { EM.stop } }
Signal.trap("TERM") { AMQP.stop { EM.stop } }

# Listen to the main queue
q = "main"
puts "Listening to the #{q} queue."

# Setup the connection directly this time
Warren::Queue.connection = {:user => "caius", :pass => "caius", :vhost => "/"}

# Set the secret key
require File.expand_path(File.dirname(__FILE__) + "/secret")
Warren::MessageFilter::SharedSecret.key = SUPER_SECRET_KEY
# And add the filter
Warren::MessageFilter << Warren::MessageFilter::SharedSecret

# And attach a block for new messages to fire
Warren::Queue.subscribe(q) do |msg|
  p [Time.now, msg]
end
