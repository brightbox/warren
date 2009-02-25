require "rubygems"
require File.expand_path(File.dirname(__FILE__) + "/../lib/warren")

Signal.trap("INT") { AMQP.stop { EM.stop } }
Signal.trap("TERM") { AMQP.stop { EM.stop } }

# Listen to the main queue
q = "main"
puts "Listening to the #{q} queue."

# Setup the connection directly this time
Warren::Queue.set_connection(:user => "caius", :pass => "caius", :vhost => "/")

# And attach a block for new messages to fire
Warren::Queue.subscribe(q) do |msg|
  p [Time.now, msg]
end
