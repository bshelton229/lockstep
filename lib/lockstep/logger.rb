module LockStep
  class Logger
    class << self
      def write(message)
        @config ||= LockStep::Config
        if log_file = @config.output
          File.open(log_file, 'a+') {|f| f.write("[#{Time.now}] #{message}\n") }
        else
          puts message
        end
      end
      
      def redirect_stdout
        STDOUT.reopen(File.open(@config.output,'a+')) if @config.output
      end
    end
  end
end
