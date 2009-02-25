class Warren::Queue
  @@connection = nil
  
  # Sets the connection details
  def self.set_connection params
    @@connection = params.is_a?(Warren::Connection) ? params : Warren::Connection.new(params)
  end
  
  #
  # Sends a payload to a queue. If successfully sent it returns
  # true, unless callback block is passed (see below)
  # 
  #   Warren::Queue.publish(:queue_name, {:foo => "name"})
  #   Warren::Queue.publish(:queue_name, #<Warren::Message>)
  # 
  # Can also pass a block which is fired after the message
  # is sent. If a block is passed, then the return value of the block
  # is returned from this method.
  # 
  #   Warren::Queue.publish(:queue_name, {:foo => "name"}  ) { puts "foo" }
  #   Warren::Queue.publish(:queue_name, #<Warren::Message>) { puts "bar" }
  # 
  def self.publish queue_name, payload, &blk
    if queue_name == :default
      queue_name = @@connection.queue_name
    end
    # Create a message object if it isn't one already
    msg = Warren::Message.new(payload) unless payload.is_a? Warren::Message
    msg ||= payload
    
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
  def self.subscribe queue_name, &block
    # todo: check if its a valid queue?
    do_connect(false) do
      queue = MQ::Queue.new(MQ.new, queue_name)
      queue.subscribe do |msg|
        msg = Warren::Message.unpack(msg)
        block.call(msg)
      end
    end
  end


  private
  
  # Connects and does the stuff its told to!
  def self.do_connect should_stop = true, callback = nil, &block
    AMQP.start(@@connection.options) do
      block.call
      AMQP.stop { EM.stop_event_loop } if should_stop
    end
    # Returns the block return value or true
    callback.nil? ? true : callback.call
  end
  
end
