$:.unshift("lib")
require 'puerto.rb'

p = Puerto.new
p.main_loop
