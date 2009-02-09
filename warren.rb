require "yaml"
require "rubygems"
require "mq"

module Warren
end

WARREN_ROOT = File.expand_path(File.dirname(__FILE__))

# Require everything in the lib folder
Dir["#{WARREN_ROOT}/lib/*.rb"].each do |file|
  require file
end
