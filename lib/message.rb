class Warren::Message
  
  def initialize payload
    @payload = payload
  end
  
  # Return itself as text for publication
  def to_s
    Warren::Message.pack @payload
  end
  
  # Packs the message up for sending
  def self.pack msg
    YAML.dump msg
  end
  
  # Unpacks the message
  def self.unpack msg
    YAML.load msg
  end
  
end