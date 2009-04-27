require "yaml"
require "rubygems"
require "mq"

#
# Library for pushing messages onto RabbitMQ queues,
# and receiving them at the other end.
#
# It handles authentication + filtering messages with custom
# classes if needed.
#
# Start with Warren::Queue for details and see also
# examples/
#
module Warren
  @@foo = ""
end

WARREN_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))

# Require everything in the lib folder
Dir["#{WARREN_ROOT}/lib/warren/**/*.rb"].each do |file|
  require file
end
