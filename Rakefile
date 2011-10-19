$:.unshift File.expand_path('../lib', __FILE__)
require 'lockstep'
require 'fileutils'

desc "Build the gem"
task :build do
  dir = File.dirname(__FILE__)
  puts "Building lockstep\n"
  system "gem build #{dir}/lockstep.gemspec"
end

desc "Build and install the gem"
task :install => :build do
  dir = File.dirname(__FILE__)
  puts "Installing lockstep\n"
  system "sudo gem install #{dir}/lockstep-#{LockStep::VERSION}.gem"
end

desc "Test Run in /tmp/lockstep"
task :test_run do
  # Create our test directories
  FileUtils.mkdir_p('/tmp/lockstep/src')
  FileUtils.mkdir_p('/tmp/lockstep/dest')
  args = ["-f", File.expand_path('../tests/lockstep.yml', __FILE__), "-d"]
  LockStep::Cli.run(args)
end

task :default => :build
