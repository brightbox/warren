require "rubygems"
require "../warren"

Signal.trap("INT") { AMQP.stop { EM.stop } }
Signal.trap("TERM") { AMQP.stop { EM.stop } }

Warren::Queue.set_connection(:user => "network", :pass => "network", :vhost => "taskomatic")
Warren::Queue.publish("reboots", {:name => "caius"})
