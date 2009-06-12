require "yaml"

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
end

WARREN_ENV = (defined?(RAILS_ENV) ? RAILS_ENV : "development") unless defined?(WARREN_ENV)
WARREN_ROOT = (defined?(RAILS_ROOT) ? RAILS_ROOT : File.dirname($0)) unless defined?(WARREN_ROOT)
WARREN_LIB_ROOT = File.expand_path(File.dirname(__FILE__))

# Require everything in the lib folder
Dir["#{WARREN_LIB_ROOT}/warren/*.rb"].each do |file|
  require file
end
