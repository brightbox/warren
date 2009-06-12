require "yaml"
module Warren
  class Connection
    
    attr_reader :options

    #
    # Creates a new connection by reading the options from
    # WARREN_ROOT/config/warren.yml or specify the file to read as an
    # argument or by passing a hash of connection details in.
    #
    # Reads WARREN_ENV out of the yaml'd hash (just like ActiveRecord)
    # "development" by default (and RAILS_ENV if running under rails)
    #
    # Raises InvalidConnectionDetails if no params are found for the current
    # environment.
    #
    def initialize params = nil
      if params.nil? || !params.is_a?(Hash)
        file ||= "#{WARREN_ROOT}/config/warren.yml"
        raise InvalidConnectionDetails, "Config file not found: #{file}" unless File.exists?(file)
        opts = YAML.load_file(file)
      end
      opts ||= params
      
      opts = symbolize_keys(opts[WARREN_ENV])
      check_connection_details(opts)
      @options = opts
    end

    #
    # Raised if connection details are missing or invalid
    # Check the error message for more details
    #
    InvalidConnectionDetails = Class.new(Exception)

    private

    #
    # Changes all keys into symbols
    #
    def symbolize_keys(hash)
      hash.each do |key, value|
        hash.delete(key)
        hash[key.to_sym] = value
      end
    end
    
    # 
    # Calls the adapter to check the connection details
    # Returns true or raises InvalidConnectionDetails
    # 
    def check_connection_details params
      return true unless Warren::Queue.adapter.respond_to?(:check_connection_details)
      Warren::Queue.adapter.send(:check_connection_details, params)
    end

  end
end