module LockStep
  class Transport
    class << self
      # Run an Rsync of local_path to each remote server
      def rsync(wait = false)
        @config ||= LockStep::Config
        @config.destinations.each do |destination|
          # See if we're to use an SSH key
          # and make sure it exists
          ssh_key = false
          if destination.identity_file and destination.hostname
            identity_file = File.expand_path(destination.identity_file)
            ssh_key = identity_file if File.exists?(identity_file)
          end

          # Build the rsync command
          command = "rsync -avz "
          command << "-e 'ssh -i #{ssh_key}' " if ssh_key
          command << "--delete " if destination.cleanup
          command << "#{@config.source_path}/ "
          command << "#{destination.user}@" if destination.user and destination.hostname
          command << "#{destination.hostname}:" if destination.hostname
          command << "#{destination.path}/"

          # A little latency
          sleep 1 if wait

          # Re-direct stdout to the log file if we're meant to
          STDOUT.reopen(File.open(LockStep::Config.output,'a+')) if LockStep::Config.output
          # Run the command
          system command
        end
      end
    end
  end
end
