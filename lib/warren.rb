require "yaml"
require "rubygems"
require "mq"

module Warren
end

WARREN_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))

# Require everything in the lib folder
Dir["#{WARREN_ROOT}/lib/warren/**/*.rb"].each do |file|
  require file
end
