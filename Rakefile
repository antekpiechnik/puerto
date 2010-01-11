require 'rubygems'
require 'yard'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*test.rb']
  t.verbose = true
end

YARD::Rake::YardocTask.new do |t|
  t.options = ['--protected', '--private', '--title', 'Puerto Rico Documentation', '--markup', 'markdown']
end

desc "Everything"
task :all => [:test, :doc] do |t|
end
