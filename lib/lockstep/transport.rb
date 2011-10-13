module LockStep
  class Transport
    class << self
      # Run an Rsync of local_path to each remote server
      def rsync(wait = false)
        @config ||= LockStep::Config
        @config.destinations.each do |destination|
          command = "rsync -avz #{@config.source_path}/ "
          command << "#{destination.user}@" if destination.user and destination.hostname
          command << "#{destination.hostname}:" if destination.hostname
          command << "#{destination.path}/"
          sleep 1 if wait
          system command
        end
      end
    end
  end
end
