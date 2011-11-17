require 'optparse'

module LockStep
  class Cli
    # Run the CLI
    def self.run(args)
      # Default options
      options = { :config_file => false, :daemonize => false, :log_file => File.join(Dir.getwd, 'lockstep.log') }
      # Parse arguments
      opts = OptionParser.new do |opts|
        # Specify the config file (mandatory)
        opts.on("-f CONFIG_FILE", "--config-file CONFIG_FILE", "Specify a config file", String) do |f|
          options[:config_file] = f
        end
        # Specify the log file to write to
        opts.on("-l LOG_FILE", "--log-file LOG_FILE", "Specify a log file", String) do |log_file|
          options[:log_file] = File.expand_path(log_file)
        end
        # Run as a daemon
        opts.on("-d", "--daemon", "Run as a daemon") do |d|
          options[:daemonize] = d
        end
        # Show the version and exit 0
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
        # To fork or not to fork
        if not options[:daemonize]
          # Start the monitor
          operations.monitor
        else
          log_file = options[:log_file]
          # Bail if we can't write to the log file
          if not File.writable? File.dirname(log_file)
            puts "Cannot write to the log file: #{log_file}"
            exit 1
          end
          # Set the log_file destination in Config
          LockStep::Config.output = log_file
          # Fork the process
          pid = fork { operations.monitor }
          STDOUT.reopen(File.open(LockStep::Config.output,'a+'))
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
