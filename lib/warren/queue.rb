class Warren::Queue
  @@connection = nil
  
  # Raised if no connection has been defined yet.
  class NoConnectionDetails < Exception
  end
  
  # Raised if a block is expected by the method but none is given.
  class NoBlockGiven < Exception
  end
  
  # Sets the connection details
  def self.set_connection params
    puts "Deprecated: Warren::Queue.set_connection - Use Warren::Queue#connection= instead."
    self.connection = params
  end
  
  # Sets the connection details
  def self.connection= params
    @@connection = params.is_a?(Warren::Connection) ? params : Warren::Connection.new(params)
  end
  
  # Returns the current connection details
  # Raises NoConnectionDetails if no connection details have been
  # assigned yet.
  def self.connection
    if @@connection.nil?
      raise NoConnectionDetails, "You need to set the connection details."
    end
    @@connection
  end
  
  #
  # Sends a message to a queue. If successfully sent it returns
  # true, unless callback block is passed (see below)
  # 
  #   Warren::Queue.publish(:queue_name, {:foo => "name"})
  # 
  # Can also pass a block which is fired after the message
  # is sent. If a block is passed, then the return value of the block
  # is returned from this method.
  # 
  #   Warren::Queue.publish(:queue_name, {:foo => "name"}) { puts "foo" }
  # 
  def self.publish queue_name, payload, &blk
    queue_name = self.connection.queue_name if queue_name == :default
    # Create a message object if it isn't one already
    msg = Warren::MessageFilter.pack(payload)
        
    do_connect(true, blk) do
      queue = MQ::Queue.new(MQ.new, queue_name)
      queue.publish msg.to_s
    end

  end
  
  #
  # Subscribes to a queue and runs the block
  # for each message received
  # 
  #   Warren::Queue.subscribe("example") {|msg| puts msg }
  # 
  # Expects a block and raises NoBlockGiven if no block is given.
  # 
  def self.subscribe queue_name, &block
    raise NoBlockGiven unless block_given?
    queue_name = self.connection.queue_name if queue_name == :default
    # todo: check if its a valid queue?
    do_connect(false) do
      queue = MQ::Queue.new(MQ.new, queue_name)
      queue.subscribe do |msg|
        msg = Warren::MessageFilter.unpack(msg)
        block.call(msg)
      end
    end
  end


  private
  
  # Connects and does the stuff its told to!
  def self.do_connect should_stop = true, callback = nil, &block
    AMQP.start(self.connection.options) do
      block.call
      AMQP.stop { EM.stop_event_loop } if should_stop
    end
    # Returns the block return value or true
    callback.nil? ? true : callback.call
  end
  
end
