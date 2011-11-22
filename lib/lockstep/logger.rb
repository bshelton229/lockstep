module Lockstep
  class Logger
    class << self
      def write(message)
        @config ||= LockStep::Config
        if log_file = @config.output
          File.open(log_file, 'a+') {|f| f.write(message) }
        else
          puts message
        end
      end
    end
  end
end
