require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'
require 'yaml'

task :default => :spec

task :spec do
    desc "Run specs"
    RSpec::Core::RakeTask.new do |t|
      t.rspec_opts = ["-c"]
    end
end
