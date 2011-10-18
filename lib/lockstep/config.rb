module LockStep

  # A host definition
  class Destination
    attr_reader :name
    attr_reader :hostname
    attr_reader :user
    attr_reader :path
    attr_reader :cleanup

    def initialize(name, hostname, user, path, cleanup = false)
      @name = name
      @hostname = hostname
      @user = user
      @path = path
      @cleanup = cleanup
    end
  end

  # Config class
  class Config

    # Load the config file
    def self.load(file)
      @config_file = File.expand_path(file)
      if File.exist? @config_file
        config = YAML::load( File.open(@config_file) )
        # @TODO: Loads of validation
        @destinations = Array.new
        config['destinations'].each do |server_name, destination|
          path = destination['path'].gsub('\/+$', '')
          cleanup = destination['cleanup'] ? true : false
          @destinations << LockStep::Destination.new(server_name, destination['hostname'], destination['user'], path, cleanup)
        end
        @source_path = File.expand_path(config['source_path'])
      else
        puts "The config file #{file} does not exist\n"
        exit 3
      end
    end

    def self.destinations
      @destinations || false
    end

    def self.source_path
      @source_path || false
    end

    def self.config_file
      @config_file || false
    end
  end
end
