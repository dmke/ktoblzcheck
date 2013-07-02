require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :spec_build do
  Dir.chdir('ext') do
    output = `ruby extconf.rb`
    raise output unless $? == 0
    output = `make`
    raise output unless $? == 0
  end
end

task spec:    :spec_build
task default: :spec
