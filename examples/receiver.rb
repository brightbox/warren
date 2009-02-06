require "rubygems"
require "../warren"

Signal.trap("INT") { AMQP.stop { EM.stop } }
Signal.trap("TERM") { AMQP.stop { EM.stop } }

q = "reboots"

puts "Listening to the #{q} queue."

Warren::Queue.set_connection(:user => "network", :pass => "network", :vhost => "taskomatic")

Warren::Queue.subscribe(q) do |msg|
  p [Time.now, msg]
end
