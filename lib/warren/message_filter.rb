require File.expand_path(File.dirname(__FILE__) + "/message_filters/yaml")

module Warren
  class MessageFilter
    # Array of filters to be run on the message before its
    # pushed to rabbit.
    # 
    # NB: These get called in reverse order from the array - 
    # the last filter to be added gets called first.
    @@filters = [Warren::MessageFilter::Yaml]

    # Adds a filter to the list
    class << self
      def << filter
        @@filters << filter
      end
      alias :add_filter :<<
    end

    # Returns a packed message
    def self.pack msg
      @@filters.reverse.each do |f|
        # puts "Packing with #{f}"
        msg = f.send(:pack, msg)
      end
      msg
    end

    # Unpacks the message
    def self.unpack msg
      @@filters.each do |f|
        # puts "Unpacking with #{f}"
        msg = f.unpack(msg)
      end
      msg
    end
    
  end
end