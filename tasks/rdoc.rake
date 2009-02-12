require "rake/rdoctask"

Rake::RDocTask.new do |rd|
  rd.main = "warren.rb"
  rd.rdoc_files.include("warren.rb", "lib/*.rb", "examples/*.rb")
  rd.rdoc_dir = "doc"
end
