$:.unshift File.expand_path('../lib', __FILE__)
require 'lockstep'

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

task :default => :build