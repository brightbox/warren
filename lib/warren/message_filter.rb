require File.expand_path(File.dirname(__FILE__) + "/message_filters/yaml")

module Warren
  # Handles filtering messages going onto/coming off the queue
  class MessageFilter
    # Array of filters to be run on the message before its
    # pushed to rabbit.
    # 
    # NB: These get called in reverse order from the array - 
    # the last filter to be added gets called first.
    @@filters = [Warren::MessageFilter::Yaml]

    class << self
      # Adds a filter to the list
      # 
      # A valid filter is just a class that defines
      # <tt>self.pack</tt> and <tt>self.unpack</tt> 
      # methods, which both accept a single argument,
      # act upon it, and return the output.
      # 
      # Example filter class (See also message_filters/*.rb)
      # 
      #     class Foo
      #       def self.pack msg
      #         msg.reverse # Assumes msg responds to reverse
      #       end
      # 
      #       def self.unpack msg
      #         msg.reverse # Does the opposite of Foo#pack
      #       end
      #     end
      # 
      def << filter
        @@filters << filter
      end
      alias :add_filter :<<
    end
    
    # Returns current array of filters
    def self.filters
      @@filters
    end
    
    # Resets the filters to default
    def self.reset_filters
      @@filters = [Warren::MessageFilter::Yaml]
    end

    # Runs the raw message through all the filters
    # and returns the filtered version
    def self.pack msg
      @@filters.reverse.each do |f|
        # puts "Packing with #{f}"
        msg = f.send(:pack, msg)
      end
      msg
    end

    # Runs the filtered message through all the
    # filters and returns the raw version
    def self.unpack msg
      @@filters.each do |f|
        # puts "Unpacking with #{f}"
        msg = f.unpack(msg)
      end
      msg
    end
    
  end
end