require "rake/rdoctask"

Rake::RDocTask.new do |rd|
  rd.main = "lib/warren.rb"
  rd.rdoc_files.include("lib/**/*.rb")
  rd.rdoc_dir = "doc"
end
