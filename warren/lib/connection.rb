class Warren::Connection
  
  attr_reader :opts
  
  def initialize opts = {}
    # Check they've passed in the stuff without a default on it
    unless opts.has_key?(:user) && opts.has_key?(:pass) && opts.has_key?(:vhost)
      raise InvalidConnectionDetails, "Missing a username, password or vhost."
    end
    @opts = opts
  end
  
  def options
    {
      :user  => @opts[:user],
      :pass  => @opts[:pass],
      :vhost => @opts[:vhost],
      :host  => (@opts[:host] || "localhost"),
      :port  => (@opts[:port] || ::AMQP::PORT.to_i),
      :logging => (@opts[:logging] || false)
    }
  end
  
  class InvalidConnectionDetails < Exception
  end
end