begin
  require "hmac-sha2"
rescue LoadError => e
  puts "Error loading the `ruby-hmac` gem."
  exit!
end

module Warren
  class MessageFilter
    class SharedSecret
      class NoKeyError < Exception; end
      class KeyValidationError < Exception; end
            
      def self.key= key
        @@key = key
      end
      
      def self.key
        raise NoKeyError if @@key.nil?
        @@key
      end
      
      def self.secret string
        HMAC::SHA256.hexdigest(self.key, string)
      end
      
      def self.pack msg
        # Make sure its a hash
        msg = {:secret_msg => msg} unless msg.is_a? Hash
        # And add our secret into the hash
        msg[:secret] = self.secret(msg.to_s)
        msg
      end
      
      def self.unpack msg
        # Check the secret exists in the msg and matches the secret_string
        raise KeyValidationError unless msg.delete(:secret) == self.secret(msg.to_s)
        # see if its a hash we created, it'll only contain the key "secret_msg" if it is
        msg = msg[:secret_msg] if msg.keys == [:secret_msg]
        msg        
      end
            
    end
  end
end
