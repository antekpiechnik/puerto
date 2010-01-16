require 'rubygems'
require 'yard'
require 'rake/testtask'
require 'rcov'

task :default => :test

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*test.rb']
  t.verbose = true
end

YARD::Tags::Library.define_tag :action, :action

class MyYardFactory < YARD::Tags::DefaultFactory
  def parse_tag_action
    # dummy
  end
end

YARD::Tags::Library.default_factory = MyYardFactory

YARD::Rake::YardocTask.new do |t|
  t.options = ['--protected', '--private', '--title', 'Puerto Rico Documentation', '--markup', 'markdown']
end

desc 'Measures test coverage'
task :coverage do
  rm_f "coverage"
  rm_f "coverage.data"
  rcov = "rcov --aggregate coverage.data --text-summary -Ilib"
  system("#{rcov} --html test/*_test.rb")
  system("open coverage/index.html") if PLATFORM['darwin']
end


desc "Everything"
task :all => [:test, :yard, :coverage]
