begin
  require "hmac-sha2"
rescue LoadError => e
  puts "Error loading the `ruby-hmac` gem."
  exit!
end

module Warren
  class MessageFilter
    # Hashes the message using a secret salt, stores the hash
    # in the message and then checks its the same when pulled
    # off the other end.
    #
    # Basic trust implementation to make sure the message
    # hasn't been tampered with in transit and came from
    # an "authorised" app.
    #
    # Make sure both the publisher and subscriber use the same
    # key else you'll get KeyValidationError error raised.
    #
    class SharedSecret < MessageFilter
      # Raised when no key (salt) is provided
      class NoKeyError < Exception; end
      # Raised when there is a key mismatch error
      class KeyValidationError < Exception; end

      # Sets the key to use
      def self.key= key
        @@key = key
      end

      # Returns the current key
      # Raises NoKeyError if no key has been assigned yet
      def self.key
        raise NoKeyError if @@key.nil?
        @@key
      end

      # Returns the hashed message
      #
      # Expects that msg#to_s returns a string
      # to hash against.
      #
      def self.secret msg
        HMAC::SHA256.hexdigest(self.key, msg.to_s)
      end

      # Called when the message is being packed for
      # transit. Returns a hash.
      def self.pack msg
        # Make sure its a hash
        msg = {:secret_msg => msg} unless msg.is_a? Hash
        # And add our secret into the hash
        msg[:secret] = self.secret(msg.to_s)
        msg
      end

      # Called when unpacking the message from transit.
      # Returns the original object.
      def self.unpack msg
        # Check the secret exists in the msg and matches the secret_string
        raise KeyValidationError unless msg.delete(:secret) == self.secret(msg)
        # see if its a hash we created, it'll only contain the key "secret_msg" if it is
        msg = msg[:secret_msg] if msg.keys == [:secret_msg]
        msg
      end

    end
  end
end
