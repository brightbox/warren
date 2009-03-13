require "yaml"

module Warren
  class MessageFilter
    # Packs the message into a YAML string
    # for transferring safely across the wire
    class Yaml
      
      # Returns a YAML string
      def self.pack msg
        YAML.dump(msg)
      end
      
      # Returns original message
      def self.unpack msg
        YAML.load(msg)
      end
    end
  end
end