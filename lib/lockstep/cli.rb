require 'optparse'

module LockStep
  class Cli
    # Run the CLI
    def self.run(args)
      # Default options
      options = { :config_file => false, :daemonize => false }
      # Parse arguments
      opts = OptionParser.new do |opts|
        opts.on("-f CONFIG_FILE", "--config-file CONFIG_FILE", "Specify a config file", String) do |f|
          options[:config_file] = f
        end
        opts.on("-d", "--daemon", "Run as a daemon") do |d|
          options[:daemonize] = d
        end
        opts.on("-V", "--version", "Lockstep version") do |v|
          puts "Lockstep: #{LockStep::VERSION}\n"
          exit 0
        end
      end
      opts.parse!(args)

      # Load the config file if we got one
      if options[:config_file]
        LockStep::Config.load(options[:config_file])
        operations = LockStep::Operations.new

        # Run an initial sync
        # operations.sync

        if not options[:daemonize]
          # Start the monitor
          operations.monitor
        else
          # Fork the process
          pid = fork { operations.monitor }
          STDOUT.reopen(File.open("./lockstep-#{pid}.log",'a+'))
          Process.detach pid
          puts "Spawned #{pid}"
        end

      else
        puts "You must supply a config file\n"
        exit 2
      end
    end
  end
end
