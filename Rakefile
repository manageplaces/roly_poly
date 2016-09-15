require 'rubygems'
require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new(:generators) do |task|
  task.pattern = 'spec/generators/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:roly_poly) do |task|
  task.pattern = 'spec/roly_poly/**/*_spec.rb'
end

if !ENV['APPRAISAL_INITIALIZED'] && !ENV['TRAVIS']
  task default: :appraisal
else
  task default: :spec
end


desc 'Run all specs'
task 'spec' do
  Rake::Task['generators'].invoke
  return_code1 = $?.exitstatus
  Rake::Task['roly_poly'].invoke
  return_code2 = $?.exitstatus
  fail if return_code1 != 0 || return_code2 != 0
end
