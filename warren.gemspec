# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{warren}
  s.version = "0.9.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Caius Durling, David Smalley"]
  s.date = %q{2009-12-21}
  s.description = %q{Library for pushing messages onto and off RabbitMQ queues}
  s.email = %q{support@brightbox.co.uk}
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "lib/warren.rb", "lib/warren/adapters/amqp_adapter.rb", "lib/warren/adapters/bunny_adapter.rb", "lib/warren/adapters/dummy_adapter.rb", "lib/warren/adapters/test_adapter.rb", "lib/warren/connection.rb", "lib/warren/filters/shared_secret.rb", "lib/warren/filters/yaml.rb", "lib/warren/message_filter.rb", "lib/warren/queue.rb", "tasks/rdoc.rake", "tasks/rspec.rake"]
  s.files = ["CHANGELOG", "LICENSE", "Manifest", "Rakefile", "examples/authed/receiver.rb", "examples/authed/secret.rb", "examples/authed/sender.rb", "examples/simple/amqp_mass_sender.rb", "examples/simple/amqp_receiver.rb", "examples/simple/amqp_sender.rb", "examples/simple/bunny_receiver.rb", "examples/simple/bunny_sender.rb", "lib/warren.rb", "lib/warren/adapters/amqp_adapter.rb", "lib/warren/adapters/bunny_adapter.rb", "lib/warren/adapters/dummy_adapter.rb", "lib/warren/adapters/test_adapter.rb", "lib/warren/connection.rb", "lib/warren/filters/shared_secret.rb", "lib/warren/filters/yaml.rb", "lib/warren/message_filter.rb", "lib/warren/queue.rb", "readme.rdoc", "spec/spec.opts", "spec/spec_helper.rb", "spec/warren/adapters/bunny_adapter_spec.rb", "spec/warren/adapters/test_adapter_spec.rb", "spec/warren/connection_spec.rb", "spec/warren/queue_spec.rb", "spec/warren/warren_spec.rb", "tasks/rdoc.rake", "tasks/rspec.rake", "warren.gemspec"]
  s.homepage = %q{http://github.com/brightbox/warren}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Warren", "--main", "readme.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{warren}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Library for pushing messages onto and off RabbitMQ queues}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<amqp>, [">= 0.6.0"])
      s.add_runtime_dependency(%q<bunny>, [">= 0.6.0"])
    else
      s.add_dependency(%q<amqp>, [">= 0.6.0"])
      s.add_dependency(%q<bunny>, [">= 0.6.0"])
    end
  else
    s.add_dependency(%q<amqp>, [">= 0.6.0"])
    s.add_dependency(%q<bunny>, [">= 0.6.0"])
  end
end
