require 'rbconfig'

module LockStep
  class Operations

    def initialize
      @config = LockStep::Config
      @latency = 1
    end

    # Run the monitor
    # Works on mac and linux
    def monitor
      # Store this instance to be used in the callbacks
      operations = self
      # Run the monitor
      FSSM.monitor(@config.source_path) do
        update {|base, relative| LockStep::Transport.send(base, relative) }
        # delete {|base, relative| LockStep::Transport.send(base, relative, true) }
        create {|base, relative| LockStep::Transport.send(base, relative) }
      end
    end

  end
end
