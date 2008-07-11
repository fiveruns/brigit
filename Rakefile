require 'rubygems'
require 'echoe'

require File.dirname(__FILE__) << "/lib/brigit/version"

Echoe.new 'brigit' do |p|
  p.version = Brigit::Version::STRING
  p.author = "FiveRuns Development Team"
  p.email  = 'dev@fiveruns.com'
  p.project = 'fiveruns'
  p.summary = "Git utilities"
  p.url = "http://github.com/fiveruns/brigit"
  p.include_rakefile = true
  p.rcov_options << '--sort coverage --exclude gems --text-summary'
end