require "rubygems"
require "../warren"

Signal.trap("INT") { AMQP.stop { EM.stop } }
Signal.trap("TERM") { AMQP.stop { EM.stop } }

# Setup our own connection for no good reason
conn = Warren::Connection.new(
  :user => "network",
  :pass => "network",
  :vhost => "taskomatic",
  :default_queue => "reboots"
)
Warren::Queue.set_connection(conn)
Warren::Queue.publish(:default, {:name => "fred"})
