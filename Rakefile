require 'rubygems'
require 'rake'

# Load in external rakefiles
Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each do | rake_file |
  load rake_file
end

# Gem stuff
require 'echoe'
Echoe.new('warren') do | gem |
  gem.author = ["Caius Durling", "David Smalley"]
  gem.email = 'support@brightbox.co.uk'
  gem.summary = 'Library for pushing messages onto and off RabbitMQ queues'
  gem.url = 'http://github.com/brightbox/warren'
  gem.dependencies = [["amqp", '>= 0.6.0']]
end

desc "Generates the manifest and the gemspec"
task :build => [:manifest, :build_gemspec] do
  puts "Built!"
end

