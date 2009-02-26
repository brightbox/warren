class Warren::Message
  
  def initialize payload
    @payload = payload
  end
  
  # Return itself as text for publication
  def payload
    Warren::Message.pack @payload
  end
  alias_method :to_s, :payload
    
  # Returns a packed payload
  def self.pack msg
    packed?(msg) ? msg : YAML.dump(msg)
  end
  
  # Unpacks the payload
  def self.unpack msg
    YAML.load msg
  end
  
  private
  
  # Checks if the msg is already a YAML string
  def self.packed? msg
    msg[/^--- /] && msg[/\n$/]
  end
  
end