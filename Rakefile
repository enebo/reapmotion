require 'rspec/core/rake_task'
require 'bundler'
Bundler::GemHelper.install_tasks

task :default => [:spec]

desc "Run specs"
RSpec::Core::RakeTask.new do |r|
  r.ruby_opts = "-J-ea -Ilib"
end
