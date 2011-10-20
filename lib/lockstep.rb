require 'rubygems'
require 'net/ssh'
require 'net/scp'
require 'yaml'
require 'fssm'

# Load everything in lockstep/
Dir[File.expand_path('../lockstep/*.rb',__FILE__)].each {|file| require file }
