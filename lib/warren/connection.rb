require "yaml"
module Warren
  class Connection

    attr_reader :options

    #
    # Creates a new connection by reading the options from
    # WARREN_ROOT/config/warren.yml or specify the file to read as an
    # argument or by passing a hash of connection details in.
    #
    #   Warren::Connection.new # reads WARREN_ROOT/config/warren.yml
    #   Warren::Connection.new("file.yml")       # reads file.yml
    #   Warren::Connection.new({"foo" => "bar"}) # uses the hash
    #
    # Reads WARREN_ENV out of the yaml'd hash (just like ActiveRecord)
    # "development" by default (and RAILS_ENV if running under rails)
    #
    # Raises InvalidConnectionDetails if no params are found for the current
    # environment.
    #
    # todo: fail nicely if the env isn't defined
    #
    def initialize params = nil
      get_connection_details(params)
      # Make the details publically accessible
      @options = @opts
    end

    #
    # Raised if connection details are missing or invalid
    # Check the error message for more details
    #
    InvalidConnectionDetails = Class.new(Exception)

    private

    #
    # Short version: This is the brain of this class and sets everything up.
    #
    # Long version: Works out where the connection details need to come from
    # (params or yml) and parses them from there. Then figures out if the details
    # are there for the current env and raises a nice error if there aren't any
    # detail for the current env. Then we symblize all the keys and get the adapter
    # to check its happy with the connection details we have.
    #
    def get_connection_details params
      case params
      when NilClass
        # Read from config/warren.yml
        read_config_file

      when String
        # See if it exists as a file
        parse_config_file(params)

      when Hash
        # Use it as-is
        @opts = params

      else
        # See if it responds to :read
        if respond_to?(:read)
          # Parse it as yaml
          parse_config(params)
        else
          # Have no idea what to do with it
          raise InvalidConnectionDetails, "Don't know what to do with the params passed. Please pass a hash, filename or nothing."
        end
      end

      # Make sure the hash keys are symbols
      @opts = symbolize_keys(@opts)
      # Parse out the current environment
      parse_environment
      # Call the adapter to figure out if the details are alright
      check_connection_details
    end

    #
    # Reads in either config/warren.yml or the passed argument as a YAML file
    #
    def read_config_file filename=nil
      filename ||= "#{WARREN_ROOT}/config/warren.yml"
      parse_config_file(filename)
    end

    #
    # Parses the config file into a hash from yaml.
    #
    def parse_config_file filename
      if File.exists?(filename)
        @opts = YAML.load_file(filename)
      else
        raise InvalidConnectionDetails, "File not found: '#{filename}'"
      end
    end

    #
    # Parses the object using YAML#load
    #
    def parse_config obj
      @opts = YAML.load(obj)
    end

    #
    # Modifies the hash into just the details for the
    # current environment, or raises InvalidConnectionDetails
    #
    def parse_environment
      # keys are symbolified already
      unless @opts.has_key?(WARREN_ENV.to_sym)
        raise InvalidConnectionDetails, "No details for current environment '#{WARREN_ENV}'"
      end
      @opts = @opts[WARREN_ENV.to_sym]
    end

    #
    # Changes all keys into symbols
    #
    def symbolize_keys(hash)
      hash.each do |key, value|
        hash.delete(key)
        # Make it recursive
        hash[key.to_sym] = (value.is_a?(Hash) ? symbolize_keys(value) : value)
      end
      hash
    end

    #
    # Calls the adapter to check the connection details
    # Returns true or raises InvalidConnectionDetails
    #
    def check_connection_details
      return true unless Warren::Queue.adapter.respond_to?(:check_connection_details)
      Warren::Queue.adapter.send(:check_connection_details, @opts)
    end

  end
end