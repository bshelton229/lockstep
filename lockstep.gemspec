Gem::Specification.new do |s|
  s.name = "lockstep"
  s.version = "0.1"
  s.authors = ["Bryan Shelton"]
  s.email = "bshelton2@wisc.edu"
  s.summary = "Sync a local directory with remote directories on file change"
  s.description = "Sync a local directory with remote directories on file change"
  s.executables = ["lockstep"]
  s.files = Dir['lib/**/*','bin/*']
  s.require_path = "lib"
  
  s.required_ruby_version     = '>= 1.8.7'
  s.required_rubygems_version = ">= 1.3.6"

  # Gem deps
  s.add_dependency "daemons", ">=  1.1.4"
  s.add_dependency "fssm", "~> 0.2"
  s.add_dependency "net-ssh"
  s.add_dependency "net-scp"
  
  s.add_development_dependency "rspec"
end
