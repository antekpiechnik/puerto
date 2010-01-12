require 'rubygems'
require 'yard'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*test.rb']
  t.verbose = true
end

# YARD::Tags::Library.define_tag :handler_method, :handler_method

# class MyYardFactory < YARD::Tags::DefaultFactory
  # def parse_tag_handler_method
    # "loal"
  # end
# end

# YARD::Tags::Library.default_factory = MyYardFactory

YARD::Rake::YardocTask.new do |t|
  t.options = ['--protected', '--private', '--title', 'Puerto Rico Documentation', '--markup', 'markdown']
end

desc "Everything"
task :all => [:test, :doc] do |t|
end
