class Warren::Queue
  @@connection = nil
  @@adapter    = nil

  #
  # Raised if no connection has been defined yet.
  #
  NoConnectionDetails = Class.new(Exception)

  #
  # Raised if a block is expected by the method but none is given.
  #
  NoBlockGiven = Class.new(Exception)
  
  # 
  # Raised if an adapter isn't set
  # 
  NoAdapterSet = Class.new(Exception)

  # 
  # Sets the current connection
  # 
  def self.connection= conn
    @@connection = (conn.is_a?(Warren::Connection) ? conn : Warren::Connection.new(conn) )
  end
  
  #
  # Returns the current connection details
  #
  def self.connection
    @@connection ||= Warren::Connection.new
  end

  # 
  # Sets the adapter when this class is subclassed.
  # 
  def self.inherited klass
    @@adapter = klass
  end
  
  # 
  # Sets the adapter manually
  # 
  def self.adapter= klass
    @@adapter = klass
  end

  # 
  # Returns the current adapter or raises NoAdapterSet exception
  # 
  def self.adapter
    @@adapter || raise(NoAdapterSet)
  end

  # 
  # Publishes the message to the queue
  # 
  def self.publish *args, &blk
    self.adapter.publish(*args, &blk)
  end
  
  # 
  # Sends the subscribe message to the adapter class
  # 
  def self.subscribe *args, &blk
    self.adapter.subscribe(*args, &blk)
  end

end
