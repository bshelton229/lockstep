require 'net/ssh'
require 'net/scp'
module LockStep
  class Transport
    class << self
      # Send using net/ssh and net/scp
      def send(base, relative)
        @config ||= LockStep::Config
        # Grab our full filename
        full = "#{base}/#{relative}"
        return true if not File.file?(full)
        # Log what we're doing
        LockStep::Logger.write "Attempting to upload: #{full}\n"
        @config.destinations.each do |destination|
          ssh_options = Hash.new
          ssh_options[:keys] = [destination.identity_file] if not destination.identity_file.nil?
          Net::SSH.start(destination.hostname, destination.user, ssh_options) do |ssh|
            ssh.exec! "mkdir -p #{destination.path}/#{File.dirname(relative)}"
            ssh.scp.upload! "#{base}/#{relative}", "#{destination.path}/#{relative}"
          end
        end
      rescue Exception => e
        puts "Caught #{e}"
      end

      # Rsync if syncing is enabled
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
