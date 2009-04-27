class Warren::Connection

  # Creates a new connection with the options passed in.
  # Requires at least a :user, :pass and :vhost else will raise
  # InvalidConnectionDetails.
  def initialize opts = {}
    # Check they've passed in the stuff without a default on it
    unless opts.has_key?(:user) && opts.has_key?(:pass) && opts.has_key?(:vhost)
      raise InvalidConnectionDetails, "Missing a username, password or vhost."
    end
    @opts = opts
  end

  # Returns the default queue name or returns InvalidConnectionDetails
  # if no default queue is defined
  def queue_name
    raise InvalidConnectionDetails, "Missing a default queue name." unless @opts.has_key?(:default_queue)
    @opts[:default_queue]
  end

  # Returns a hash of the connection options
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

  # Raised if connection details are missing or invalid
  # Check the error message for more details
  class InvalidConnectionDetails < Exception
  end
end