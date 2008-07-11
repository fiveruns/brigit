require 'test/unit'
require 'rubygems'
require 'Shoulda'
require 'flexmock/test_unit'

require File.dirname(__FILE__) << "/../lib/brigit"

class Test::Unit::TestCase
  
  def gitify!(location, origin = nil)
    Dir.chdir location do
      `git init; git add .; git commit -a -m 'For test'`
      if origin
        `git remote add origin '#{origin}'`
      end
    end
  end
  
  def degitify!(location)
    FileUtils.rm_rf File.join(location, '.git') rescue nil
  end
  
  def mock_stderr!
    @old_stderr = $stderr
    $stderr = StringIO.new
  end
  
  def restore_stderr!
    $stderr = @old_stderr
  end
  
  def stderr_output
    $stderr.rewind
    $stderr.read
  end
  
end