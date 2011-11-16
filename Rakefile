require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

# Load the rpsec rake tasks
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w(-fs --color)
end

task :default => :spec
