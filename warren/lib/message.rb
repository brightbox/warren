class Warren::Message
  
  def initialize payload
    @payload = payload
  end
  
  # Return itself as text for publication
  def to_s
    @payload.to_yaml
  end
  
  def self.rubify msg
    YAML.load( msg )
  end
  
end