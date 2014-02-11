require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :spec_build do
  Dir.chdir('ext/ktoblzcheck') do
    output = `ruby extconf.rb`
    raise output unless $? == 0
    output = `make`
    raise output unless $? == 0
  end
end

task spec:    :spec_build
task default: :spec

task console: :spec_build do
  lib = File.expand_path('../lib', __FILE__)
  $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

  require 'irb'
  require 'irb/completion'
  require 'ktoblzcheck'
  ARGV.clear
  IRB.start
end
