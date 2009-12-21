require "rubygems"
gem "bunny", ">= 0.6.0"
require "bunny"

module Warren
  class Queue
    class BunnyAdapter < Queue

      # 
      # Checks the connection details are correct for this adapter
      # 
      def self.check_connection_details opts
        # Check they've passed in the stuff without a default on it
        [:user, :pass, :vhost].each do | required_arg |
          unless opts.has_key?(required_arg)
            raise Warren::Connection::InvalidConnectionDetails, "#{required_arg.to_s.capitalize} not specified"
          end
        end
        true
      end

      # 
      # Returns the default queue name or returns InvalidConnectionDetails
      # if no default queue is defined
      # 
      def self.queue_name
        unless self.connection.options.has_key?(:default_queue)
          raise Warren::Connection::InvalidConnectionDetails, "Missing a default queue name."
        end
        self.connection.options[:default_queue]
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
        queue_name = self.queue_name if queue_name == :default
        # Create a message object if it isn't one already
        msg = Warren::MessageFilter.pack(payload)

        do_connect(queue_name, blk) do |queue|
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
      # The block is passed up to two arguments, depending on how many
      # you ask for. The first one is always required, which is the message
      # passed over the queue (after being unpacked by filters.)
      # The (optional) second argument is a hash of headers bunny gives us
      # containing extra data about the message.
      # 
      #   Warren::Queue.subscribe(:default) {|msg, payload| puts msg, payload }
      # 
      def self.subscribe queue_name, &block
        raise NoBlockGiven unless block_given?
        queue_name = self.queue_name if queue_name == :default
        # todo: check if its a valid queue?
        do_connect(queue_name) do |queue|
          handle_bunny_message(queue.pop, &block)
        end
      end

      private

      # Called when a message is pulled off the queue by bunny.
      #
      def self.handle_bunny_message headers, &block
        payload = headers.delete(:payload)
        return if payload == :queue_empty
        # unpack it
        payload = Warren::MessageFilter.unpack(payload)
        # Call our block with as many args as we need to
        block.arity == 1 ? block.call(payload) : block.call(payload, headers)
      end

      #
      # Connects and does the stuff its told to!
      #
      def self.do_connect queue_name, callback = nil, &block
        # Open a connection
        b = Bunny.new(self.connection.options)
        b.start
        # Create the queue
        q = b.queue(queue_name)
        # Run the code on the queue
        block.call(q)
        # And stop
        b.stop
        # Returns the block return value or true
        callback.nil? ? true : callback.call
      end

    end
  end
end