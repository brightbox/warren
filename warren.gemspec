# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{warren}
  s.version = "0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Caius Durling, David Smalley"]
  s.date = %q{2009-03-13}
  s.description = %q{Library for pushing messages onto and off RabbitMQ queues}
  s.email = %q{support@brightbox.co.uk}
  s.extra_rdoc_files = ["CHANGELOG", "lib/warren/connection.rb", "lib/warren/message_filter.rb", "lib/warren/message_filters/shared_secret.rb", "lib/warren/message_filters/yaml.rb", "lib/warren/queue.rb", "lib/warren.rb", "tasks/rdoc.rake", "tasks/rspec.rake"]
  s.files = ["CHANGELOG", "examples/authed/receiver.rb", "examples/authed/secret.rb", "examples/authed/sender.rb", "examples/simple/mass_sender.rb", "examples/simple/receiver.rb", "examples/simple/sender.rb", "lib/warren/connection.rb", "lib/warren/message_filter.rb", "lib/warren/message_filters/shared_secret.rb", "lib/warren/message_filters/yaml.rb", "lib/warren/queue.rb", "lib/warren.rb", "LICENCE", "Manifest", "Rakefile", "readme.rdoc", "spec/hash_extend.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/warren/connection_spec.rb", "spec/warren/message_filter_spec.rb", "spec/warren/queue_spec.rb", "tasks/rdoc.rake", "tasks/rspec.rake", "warren.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/brightbox/warren}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Warren", "--main", "readme.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{warren}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Library for pushing messages onto and off RabbitMQ queues}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<amqp>, [">= 0.6.0"])
    else
      s.add_dependency(%q<amqp>, [">= 0.6.0"])
    end
  else
    s.add_dependency(%q<amqp>, [">= 0.6.0"])
  end
end
