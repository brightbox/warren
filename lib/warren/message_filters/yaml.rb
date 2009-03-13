require "yaml"

module Warren
  class MessageFilter
    class Yaml
      
      def self.pack msg
        YAML.dump(msg)
      end
      
      def self.unpack msg
        YAML.load(msg)
      end
      
    end
  end
end