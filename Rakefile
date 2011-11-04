$:.unshift File.expand_path('../lib', __FILE__)
require 'lockstep'
require 'bundler/gem_tasks'

desc "Test Run in /tmp/lockstep"
task :test_run do
  # Create our test directories
  FileUtils.mkdir_p('/tmp/lockstep/src')
  FileUtils.mkdir_p('/tmp/lockstep/dest')
  args = ["-f", File.expand_path('../tests/lockstep.yml', __FILE__), "-d"]
  LockStep::Cli.run(args)
end

task :default => :build
